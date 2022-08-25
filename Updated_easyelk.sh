#!/bin/bash
echo "---------------------------------------------------------------"
echo " $(date)"
echo " Starting easyELK Installer "
echo " ELK Stack for Debian-based Systems "
echo " Elasticsearch - Kibana "
echo "---------------------------------------------------------------"
echo " easyELK Status "
echo ""
echo " System Update... "

sudo DEBIAN_FRONTEND=noninteractive apt-get -yq update > /dev/null
sudo DEBIAN_FRONTEND=noninteractive apt-get -yq upgrade > /dev/null

echo " System Update - Complete "
echo " Install Java 8... "

# ref: https://computingforgeeks.com/how-to-install-java-8-on-ubuntu/
sudo DEBIAN_FRONTEND=noninteractive apt-get -yq install default-jre wget > /dev/null

echo " InstallJava latest - Complete "
echo " Install Elasticsearch... "

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get -yq install apt-transport-https > /dev/null
echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list > /dev/null
sudo DEBIAN_FRONTEND=noninteractive apt-get -yq update > /dev/null && sudo DEBIAN_FRONTEND=noninteractive apt-get -yq install elasticsearch > /dev/null

echo " Install Elasticsearch - Complete "
echo " Installing Kibana... "

sudo DEBIAN_FRONTEND=noninteractive apt-get -yq update > /dev/null && sudo DEBIAN_FRONTEND=noninteractive apt-get -yq install kibana > /dev/null

echo " Install Kibana - Complete "
echo " Starting Elastic, Logstash, Kibana Services "

sudo /bin/systemctl -q daemon-reload > /dev/null
sudo /bin/systemctl -q enable elasticsearch.service > /dev/null
sudo /bin/systemctl -q enable kibana.service > /dev/null
sudo /bin/systemctl -q start elasticsearch.service > /dev/null
sudo /bin/systemctl -q start kibana.service > /dev/null

echo " Service Status: "
function checkIt()
{
 ps auxw | grep -P '\b'$1'(?!-)\b' >/dev/null
 if [ $? != 0 ]
 then
   echo $1" Not Running";
 else
   echo $1" Running";
 fi;
}

checkIt "   elasticsearch"
checkIt "   kibana"

echo " $(date)"
echo " Finished easyELK Installer"
echo " Your Turn: Finish Configuration "
echo "---------------------------------------------------------------"
