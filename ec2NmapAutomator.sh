read -p "Which EC2 Instances do you want to scan? (This command searches EC2 Name Tags) " cluster_name
read -p "Which scan type are you looking to perform against the cluster? (Network | Port | Script | Full | UDP | Vulns | Recon | All) " scan_type

if ! command -v aws &> /dev/null
then
    echo "AWS CLI is not installed, installing"
    apt-get update && apt-get install awscli -y
    aws configure
else
    echo "AWS CLI is installed. Great"
fi

if ! command -v jq &> /dev/null
then
    echo "jq is not installed, installing"
    apt-get update && apt-get install jq -y
else
    echo "jq is installed. Great"
fi


echo using aws cli to get private ip addresses of the cluster...

for ip in $(aws ec2 describe-instances --filters "Name=tag:Name,Values=*${cluster_name}*" | jq -r '.Reservations[].Instances[].PrivateIpAddress'); do
		command="./nmapAutomator.sh -H $ip -t $scan_type"
		echo got $ip
		echo running $command
		./nmapAutomator.sh -H $ip -t $scan_type 
done


