#!/bin/bash
#################################################

#UPGRADING & UPDATING THE SERVER

#################################################


 sudo apt update && sudo apt upgrade -y < /dev/null

##################################################



#################################################


# INSTALLATION OF LAMP STACK


################################################ 
 sudo apt-get install apache2 -y < /dev/null

 sudo apt get install mysql-server -y < /dev/null

 sudo add-apt-repository -y ppa:ondrej/php < /dev/null

 sudo apt-get update < /dev/null

 sudo apt-get install libapache2-mod-php php php-common php-xml
 php-mysql php-gd php-mbstring php-tokenizer php-json php-bcmath
 php-curl php zip unzip -y

 sudo sed -i 's/cgi.fix_pathinfom1/cgi.fix_pathinfom0/'/etc/php/8.2/apache2/php.ini

 sudo systemctl restart apache2 < /dev/null


##################################################

#############################################################

 #CLONE LARAVEL APPLICATION AND DEPENDENCIES

#############################################################

 mkdir /var/www/html/laravel && cd /var/www/html/laravel

 cd /var/www/html && git clone https://github.com/laravel/laravel.git

 cd /var/www/html/laravel && composer install --no-dev < /dev/null

 sudo chown -R www data:www-data /var/www/html/laravel

 sudo chmod -R 775 /var/www/html/laravel

 sudo chmod -R 775 /var/www/html/laravel/storage

 sudo chmod -R 775 /var/www/html/laravel/bootstrap/cache

 cd /var/www/html/laravel && sudo cp .env.example .env

 php artisan key:generate

#####################################################
   
   # INSTALL COMPOSER

#################################################### 

 sudo apt install curl -y

 curl sS https://getcomposer.org/installer |php

 sudo mv composer.phar /usr/local/bin/composer

 composer --version < /dev/null

####################################################


#####################################################
 #CONFIGURATION OF APACHE2

####################################################

 cat << EOF >/etc/apache2/site-available/laravel.conf
 <VirtualHost ":80>
     ServerAdmin rinsolaoba07@gmail.com
     ServerName 192.168.20.10
     DocumentRoot /var/www/html/laravel/public

     <Directory /var/www/html/laravel>
     Options Indexes Multiviews FollowSymlinks
     AllowOverride All
     Require all granted
     </Directory>

     ErrorLog ${APACHE_LOG_DIR}/error.log
     CustomLog ${APACHE_LOG_DIR}/access.log combined
 </VirtualHost>
 EOF

 sudo a2enmod rewrite

 sudo a2ensite laravel.conf

 sudo systemct1 restart apache2

############################################################


###########################################################

# CONFIGURING MYSQL: CREATING USER AND PASSWORD

###########################################################

 echo "Creating MySQL user and database"
 PASS=$2
 if [-z "$2" ]; then
  PASS=openss1 rand -base64 8'
 fi


 mysql -u root <<MYSQL_SCRIPT
 CREATE DATABASE $1;
 CREATE USER '$1'@'localhost' IDENTIFIED BY '$PASS';
 GRANT ALL PRIVILEGES ON $1." TO '$1'@'localhost';
 FLUSH PRIVILEGES;
 MYSQL_SCRIPT

 echo "MySQL user and database created."
 echo "Username: $1"
 echo "Database: $1"
 echo "password: $PASS"

 ################################################################

 #EXECUTE KEY GENERATE AND MIGRATE COMMAND FOR PHP

 #################################################################

  sudo sed -i 's/DB_DATABASE=laravel/DB_DATABASE=rinsola/' /var/www/html/laravel/.env

  sudo sed -i 's/DB_USERNAME=laravel/DB_USERNAME=rinsola/' /var/www/html/laravel/.env

  sudo sed -i 's/DB_PASSWORD=laravel/DB_PASSWORD=rinsolaoba/' /var/www/html/laravel/.env
  
  php artisan config:cache

  cd /var/www/html/laravel && php artisan migrate

 ##################################################################
  
