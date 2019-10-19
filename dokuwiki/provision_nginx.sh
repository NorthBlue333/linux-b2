sudo yum -y install epel-release
sudo yum -y install nginx
sudo systemctl enable --now nginx
sudo mkdir -p /etc/nginx/sites-available
sudo mkdir -p /etc/nginx/sites-enabled
sudo mv wiki.conf /etc/nginx/sites-available/wiki.conf
sudo cp /etc/nginx/sites-available/wiki.conf /etc/nginx/sites-enabled/
sudo chmod -R 755 /etc/nginx/sites-available
sudo chmod -R 755 /etc/nginx/sites-enabled
sudo sed -i "$(cat /etc/nginx/nginx.conf | grep -n "}" | cut -d ':' -f 1 | tail -1)i include /etc/nginx/sites-enabled/*;\ndisable_symlinks off;\n" /etc/nginx/nginx.conf
sudo systemctl restart nginx
