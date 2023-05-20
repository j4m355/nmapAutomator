read -p "Which ECS Cluster do you want to scan? " cluster_name
read -p "Which directory do you want your report to be output to? " output_filepath
echo using aws cli to get private ip addresses of the cluster...

for ip in $(aws ec2 describe-instances --filters "Name=tag:Name,Values=*${cluster_name}*" | jq -r '.Reservations[].Instances[].PrivateIpAddress'); do
		command="./nmapAutomator.sh -H $ip -t All"
		echo got $ip
		echo running $command
		./nmapAutomator.sh -H $ip -t All > $output_filepath/nmap-automator-$ip-date-$(date '+%d-%m-%Y-%H-%M').log
done


