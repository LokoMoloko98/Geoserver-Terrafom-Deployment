#!/bin/bash
yum update -y
sysctl -w vm.max_map_count=262144
yum install docker -y
systemctl start docker
curl -L "https://github.com/docker/compose/releases/download/v2.12.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version
yum install python3 -y
yum install python3-pip -y
yum install git -y
yum git-core git-buildpackage debhelper devscripts python3.10-dev python3.10-venv virtualenvwrapper
yum install python3.12-venv

# Extract information about the Instance
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
INSTANCE_ID=`curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/instance-id`

NEW_NAME_TAG="geonode-instance"
REGION=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/[a-z]$//')
aws ec2 create-tags --resources $INSTANCE_ID --tags Key=Name,Value="$NEW_NAME_TAG" --region $REGION

DOMAIN_NAME="moloko-mokubedi.co.za"
LOWERCASE_TENANT_ID="geonode"
RECORD_NAME="$LOWERCASE_TENANT_ID.$DOMAIN_NAME."
HOSTED_ZONE_ID=${hostzone} # replace with your Route53 Hosted Zone ID
TTL=300 # time to live for the record in seconds


# Get the IP address of the EC2 instance
IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4/ -H "X-aws-ec2-metadata-token: $${TOKEN}")

# Check if the A record already exists
EXISTING_RECORD=$(aws route53 list-resource-record-sets --hosted-zone-id "$HOSTED_ZONE_ID" --query "ResourceRecordSets[?Name=='$RECORD_NAME'].ResourceRecords[].Value | [0]" --output text)


# If the record exists and the IP is different, or if the record does not exist, upsert the record
if [ "$EXISTING_RECORD" != "$IP" ]; then
    JSON=$(cat <<EOM
{
    "Comment": "Update record",
    "Changes": [
        {
            "Action": "UPSERT",
            "ResourceRecordSet": {
                "Name": "$RECORD_NAME",
                "Type": "A",
                "TTL": $TTL,
                "ResourceRecords": [
                    {
                        "Value": "$IP"
                    }
                ]
            }
        }
    ]
}
EOM
)
    aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch "$JSON"
fi


cd ~/

python3 -m venv ~/.venvs/the_geonode
source ~/.venvs/the_geonode/bin/activate
pip install Django==4.2.9

mkdir ~/the_geonode
GN_VERSION=master

django-admin startproject --template=https://github.com/GeoNode/geonode-project/archive/refs/heads/$GN_VERSION.zip -e py,sh,md,rst,json,yml,ini,env,sample,properties -n monitoring-cron -n Dockerfile project_name ~/the_geonode

cd ~/the_geonode
python create-envfile.py

docker-compose up -d