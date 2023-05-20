read -p "Which ECS Cluster do you want to scan? " cluster_name
read -p "Which directory do you want your report to be output to? " output_filepath

if ! command -v aws &> /dev/null
then
    echo "AWS CLI is not installed, installing"
    apt-get update && apt-get install awscli -y
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
		command="./nmapAutomator.sh -H $ip -t All"
		echo got $ip
		echo running $command
		./nmapAutomator.sh -H $ip -t All > $output_filepath/nmap-automator-$ip-date-$(date '+%d-%m-%Y-%H-%M').log
done


