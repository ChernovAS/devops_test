#/!bin/bash
#######################################
sleep 3
echo "==============================="
echo "===PREPARING FOR DNF UPDATE===="
echo "==============================="
sleep 3
YUM_REPO=/etc/yum.repos.d/
sudo sed -i 's/mirrorlist/#mirrorlist/g' $YUM_REPO/CentOS-* && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' $YUM_REPO/CentOS-*
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
sudo dnf update -y
sudo dnf makecache
sleep 3
echo "==============================="
echo "====INSTALLING DEPENDENCIES===="
echo "==============================="
cd /home
sudo dnf install epel-release python39 -y
sudo dnf install python39-PyYAML python39-cryptography python39-six prometheus-client -y
wget http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/ansible-core-2.13.3-1.el8.x86_64.rpm
wget http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/sshpass-1.09-4.el8.x86_64.rpm
sudo rpm -ivh sshpass-1.09-4.el8.x86_64.rpm ansible-core-2.13.3-1.el8.x86_64.rpm
sleep 3
echo "==============================="
echo "====INSTALLING      ANSIBLE===="
echo "==============================="
sudo mkdir -p /etc/dashboards/python_app/
ANSIBLE=/vagrant/ansible
ansible-galaxy init $ANSIBLE/roles/nginx
ansible-galaxy init $ANSIBLE/roles/grafana
git clone https://github.com/MiteshSharma/PrometheusWithAnsible
cp -pR PrometheusWithAnsible/roles/* $ANSIBLE/roles/
y | sudo mv $ANSIBLE/prometheus.conf.j2 $ANSIBLE/roles/prometheus/templates/
y | sudo mv $ANSIBLE/main_task_nginx.yml roles/nginx/tasks/main.yml
y | sudo mv $ANSIBLE/main_task_grafana.yml roles/grafana/tasks/main.yml
sudo mv $ANSIBLE/grafana.ini roles/grafana/templates/grafana.ini
sudo mv $ANSIBLE/datasources.yml roles/grafana/templates/datasources.yml
sudo mv $ANSIBLE/dashboards.yml roles/grafana/templates/dashboards.yml
sudo mv $ANSIBLE/httprequests.json roles/grafana/templates/httprequests.json
sudo mv $ANSIBLE/nginx.conf roles/nginx/templates/nginx.conf
sleep 3
#!!!!!INSTALL PYTHON APP
sudo mkdir -p $ANSIBLE/projects/python
mv $ANSIBLE/webapp.py $ANSIBLE/project/python/
python3 webapp.py
sleep 3
echo "==============================="
echo "====ANSIBLE           START===="
echo "==============================="
ansible-playbook -i $ANSIBLE/hosts $ANSIBLE/playbook.yml
sleep 3
echo "==============================="
echo "====IPTABLES  CONFIGURATION===="
echo "==============================="
#configuration
sleep 3
echo "==============================="
echo "====SELINUX   CONFIGURATION===="
echo "==============================="
#configuration
sleep 3