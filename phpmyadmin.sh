sudo apt update -y
sudo apt install apache2 wget unzip -y
sudo apt install php php-zip php-json php-mbstring php-mysql -y
sudo systemctl enable apache2 
sudo systemctl start apache2 
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.zip 
unzip phpMyAdmin-5.2.0-all-languages.zip 
sudo mv phpMyAdmin-5.2.0-all-languages /usr/share/phpmyadmin
sudo mkdir /usr/share/phpmyadmin/tmp 
sudo chown -R www-data:www-data /usr/share/phpmyadmin 
sudo chmod 777 /usr/share/phpmyadmin/tmp
/bin/cat <<"EOM" >/etc/apache2/conf-available/phpmyadmin.conf
Alias /phpmyadmin /usr/share/phpmyadmin
Alias /phpMyAdmin /usr/share/phpmyadmin
 
<Directory /usr/share/phpmyadmin/>
   AddDefaultCharset UTF-8
   <IfModule mod_authz_core.c>
      <RequireAny>
      Require all granted
     </RequireAny>
   </IfModule>
</Directory>
 
<Directory /usr/share/phpmyadmin/setup/>
   <IfModule mod_authz_core.c>
     <RequireAny>
       Require all granted
     </RequireAny>
   </IfModule>
</Directory>
EOM
chmod 777 /etc/apache2/conf-available/phpmyadmin.conf
sudo a2enconf phpmyadmin 
sudo systemctl restart apache2 
sudo firewall-cmd --permanent --add-service=http 
sudo firewall-cmd --reload

cd
sudo apt update -y
sudo apt install mysql-server -y
sudo systemctl start mysql.service
mysql
CREATE DATABASE  codeph;
CREATE USER 'codeph'@'localhost' IDENTIFIED BY 'codeph';
GRANT ALL ON codeph.* TO 'codeph'@'localhost';
FLUSH PRIVILEGES;
exit
mysql -h localhost -u root
UPDATE mysql.user SET authentication_string=null WHERE User='root';
ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'codeph';
FLUSH PRIVILEGES;
exit;
