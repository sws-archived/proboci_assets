#!/bin/bash

# Several guidelines that I tried to follow when writing this file:
# 1. Limit stdout to what might break or returns test results, which also speeds up builds.
# 2. To specify the full path, ie. /root/directory, rather than ~/directory.

# Set feature and product specific variables
cd /src
test_feature=$(ls *.info | cut -f1 -d".")
profile_name=$1

# Configure keys
chmod 400 /root/.ssh/id_rsa

# Configure MySQL
# Not able to get rid of this section, tested 3fbbd6207a15d and 4994b9120bede9
service mysql start
echo 'export PATH="/usr/local/bin:$PATH"' >> /root/.bash_profile
echo 'export PATH="/usr/bin/mysql:$PATH"' >> /root/.bash_profile
source /root/.bash_profile
mysql -u root -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('root')";
mysql -u root -proot -e "CREATE DATABASE html";
cp /srv/proboci_assets/.my.cnf /root/.my.cnf
service mysql start
service mysql reload
service mysql restart

# Installing node modules
npm install -g npm >/dev/null
npm install -g selenium-standalone chromedriver >/dev/null
selenium-standalone install --silent

# Installing Behat
git clone https://github.com/SU-SWS/linky_clicky.git /srv/linky_clicky
cd /srv/linky_clicky
composer install &>/dev/null &
cp /srv/proboci_assets/aliases.drushrc.php /root/.drush/aliases.drushrc.php
cp /srv/proboci_assets/behat.yml /srv/linky_clicky/sites/probo/behat.yml
cp /srv/proboci_assets/behat.local.yml /srv/linky_clicky/sites/probo/behat.local.yml
cp /srv/linky_clicky/includes/features/SU-SWS/$test_feature/$test_feature.feature /srv/linky_clicky/sites/probo/features/.

# Downloading make files for self-service or Jumpstart site based on user input
if [ -z "$profile_name" || "$profile_name" == "stanford" ]; then
  git clone https://github.com/SU-SWS/Stanford-Drupal-Profile.git /srv/Stanford-Default-Profile
  cd /srv/Stanford-Default-Profile
  drush make make/dept.make /var/www/html
else
  git clone git@github.com:SU-SWS/stanford-jumpstart-deployer.git /srv/stanford-jumpstart-deployer
  cd /srv/stanford-jumpstart-deployer
  drush make production/product/$test_deployer_product/$test_deployer_product.make /var/www/html
fi

cp /srv/proboci_assets/.htaccess /var/www/html/.htaccess
mkdir -p /var/www/html/sites/default/files/styles
chmod -R 777 /var/www/html/sites/default/files
cd /var/www/html
drush si $profile_name --account-name=admin --db-url="mysql://root:root@localhost/html"

# Run relevant Behat tests
echo "127.0.0.1 html" >> /etc/hosts
export SHELL=/bin/sh
xvfb-run --server-args="-screen 0, 1366x768x24" selenium-standalone start > xvfb.log 2>&1 &
cd /srv/linky_clicky/sites/probo
timeout 10m /srv/linky_clicky/bin/behat -vvv -p default -s all features
