sudo yum -y install httpd mod_ssl
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum -y install yum-utils
sudo yum-config-manager --enable remi-php70
sudo yum -y install php php-xml php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo
sudo systemctl enable firewalld --now
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --reload
sudo yum -y install php-gd
sudo yum -y install policycoreutils-python
curl https://download.dokuwiki.org/out/dokuwiki-8a269cc015a64b40e4c918699f1e1142.tgz --output dokuwiki.tgz
tar xvf dokuwiki.tgz -C /var/www
sudo mkdir /etc/httpd/sites-available
sudo mv dokuwiki.conf /etc/httpd/sites-available/dokuwiki.conf
sudo ln -s /etc/httpd/sites-available /etc/httpd/sites-enabled
sudo chown -R $(cat /etc/passwd | grep apache | cut -d ':' -f 3):$(cat /etc/passwd | grep apache | cut -d ':' -f 4) /etc/httpd/sites-available
sudo chown -R $(cat /etc/passwd | grep apache | cut -d ':' -f 3):$(cat /etc/passwd | grep apache | cut -d ':' -f 4) /var/www/*
sudo echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf
sudo semanage permissive -a httpd_t
sudo systemctl enable httpd --now
