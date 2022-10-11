cat start.txt
echo "starting of scripting" > start.txt

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

echo "docker installed" > start.txt

