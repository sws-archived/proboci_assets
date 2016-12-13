#!/bin/bash

# Several guidelines that I tried to follow when writing this file:
# 1. Limit stdout to what might break or returns test results, which also speeds up builds.
# 2. To specify the full path, ie. /root/directory, rather than ~/directory.

# Set feature and product specific variables
test_deployer_product='jumpstart-academic'
test_feature=$(cd /src | echo *.info | cut -f1 -d".")

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

# Installing drush 8
# sudo mkdir --parents /opt/drush-8.x
# cd /opt/drush-8.x
# sudo composer init --require=drush/drush:8.* -n
# sudo composer config bin-dir /usr/local/bin
# sudo composer install &>/dev/null &

# Installing node modules
npm install -g npm >/dev/null
npm install -g selenium-standalone chromedriver >/dev/null
selenium-standalone install --silent

# Installing Behat
git clone https://github.com/SU-SWS/linky_clicky.git /srv/linky_clicky
cd /srv/linky_clicky
composer install &>/dev/null &
git checkout proboci
cp /srv/proboci_assets/aliases.drushrc.php /root/.drush/aliases.drushrc.php
cp /srv/proboci_assets/behat.yml /srv/linky_clicky/sites/probo/behat.yml
cp /srv/proboci_assets/behat.local.yml /srv/linky_clicky/sites/probo/behat.local.yml
mkdir /srv/linky_clicky/run_behats
git clone https://github.com/kbrownell/run_behats.git /srv/linky_clicky/run_behats
cd /srv/linky_clicky/run_behats
git checkout proboci
chmod +x run_behats.sh
cp /srv/linky_clicky/includes/features/SU-SWS/$test_feature/$test_feature.feature /srv/linky_clicky/sites/probo/features/.

# Downloading and running Jumpstart Deployer
git clone git@github.com:SU-SWS/stanford-jumpstart-deployer.git /srv/stanford-jumpstart-deployer
cd /srv/stanford-jumpstart-deployer
drush make development/product/$test_deployer_product/$test_deployer_product.make /var/www/html
cp /srv/proboci_assets/.htaccess /var/www/html/.htaccess
mkdir -p /var/www/html/sites/default/files/styles
chmod -R 777 /var/www/html/sites/default/files

# Build site
cd /var/www/html/profiles
test_product_profile=$(echo stanford_sites_jumpstart_*)
service mysql start
service mysql reload
service mysql restart
cd /var/www/html
drush si $test_product_profile --account-name=admin --db-url="mysql://root:root@localhost/html"

# Run relevant Behat tests
drush @probo.html pm-list
echo "127.0.0.1 html" >> /etc/hosts
export SHELL=/bin/sh
xvfb-run --server-args="-screen 0, 1366x768x24" selenium-standalone start > xvfb.log 2>&1 &
drush @probo.html pm-list
/srv/linky_clicky/run_behats/run_behats.sh
