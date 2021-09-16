#!/bin/bash
echo "####"
echo "##   Presearch Community Node Installation Script"
echo "####"
echo ""
echo "Paste or write down you registration code and hit <<enter>>:"
read regCode
echo ""
echo "####"
echo "##  Your registration code: $regCode"
echo "####"
echo "If its not matching try rerun again!!"
echo ""

echo "####"
echo "## Docke installation"
echo "####"
echo "Any previous installation of docker have to be removed (optional for new VPS machines / clean installs)"
sudo apt remove docker docker-engine docker.io containerd runc docker-ce docker-ce-cli containerd.io >/dev/null 2>&1
echo "Updating Ubuntu repository to latest state"
sudo apt update -y >/dev/null 2>&1
echo "Doing app upgrade so that we work with latest ones (system update)"
sudo apt upgrade -y >/dev/null 2>&1
echo "Installing docker the Ubuntu way"
sudo apt install docker.io -y >/dev/null 2>&1
echo "Adding current user to docker group so that we can execute it without root priviledges"
sudo usermod -a -G docker `whoami`
echo ""
echo "####"
echo "## Presearch node installation"
echo "####"
echo "Cleaning uo aby previous node installation"
docker stop presearch-node >/dev/null 2>&1
docker rm presearch-node >/dev/null 2>&1
docker stop presearch-auto-updater >/dev/null 2>&1
docker rm presearch-auto-updater >/dev/null 2>&1
echo "Node auto-updater installation"
docker run -d --name presearch-auto-updater --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --interval 300 presearch-node
echo "Presearch node installation"
docker run -dt --name presearch-node --restart=unless-stopped -v presearch-node-storage:/app/node -e REGISTRATION_CODE=$regCode presearch/node
y
echo ""
# displays used registration code for cross-check
echo  "Please check your registration code !!!"
docker container inspect presearch-node | grep REGISTRATION | tr -d '[:space:],"' | xargs
echo ""
# display logs
docker logs -f presearch-node
