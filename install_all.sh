#!/bin/bash


read -rsp "Please enter sudo password:" passwrd
read -rsp "Please enter mysql root password:" sql_passwrd
read -rsp "Please enter stie admin password:" admin_pass
echo -e "What is your time zone? (e.g.: Africa/Ceuta)\n (Hint: if you don't know your time zone identifier, checkout the following Wikipedia page:\nhttps://en.wikipedia.org/wiki/List_of_tz_database_time_zones)"
read -p "" timez
echo $passwrd | sudo -S timedatectl set-timezone "$timez"
echo $passwrd | sudo -S apt-get update -y
echo $passwrd | sudo -S NEEDRESTART_MODE=a apt-get upgrade -y
echo $passwrd | sudo -S NEEDRESTART_MODE=a apt -qq install nano git curl -y
echo $passwrd | sudo -S NEEDRESTART_MODE=a apt -qq install python3-dev python3.10-dev python3-pip -y
echo $passwrd | sudo -S NEEDRESTART_MODE=a apt -qq install python3.10-venv -y
echo $passwrd | sudo -S NEEDRESTART_MODE=a apt -qq install cron software-properties-common mariadb-client mariadb-server -y
echo $passwrd | sudo -S NEEDRESTART_MODE=a apt -qq install supervisor redis-server xvfb libfontconfig wkhtmltopdf -y
MARKER_FILE=~/.MariaDB_handled.marker

if [ ! -f "$MARKER_FILE" ]; then
 echo $passwrd | sudo -S mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$sql_passwrd';"
 echo $passwrd | sudo -S mysql -u root -p"$sql_passwrd" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$sql_passwrd';"
 echo $passwrd | sudo -S mysql -u root -p"$sql_passwrd" -e "DELETE FROM mysql.user WHERE User='';"
 echo $passwrd | sudo -S mysql -u root -p"$sql_passwrd" -e "DROP DATABASE IF EXISTS test;DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
 echo $passwrd | sudo -S mysql -u root -p"$sql_passwrd" -e "FLUSH PRIVILEGES;"
 echo $passwrd | sudo -S bash -c 'cat << EOF >> /etc/mysql/my.cnf
[mysqld]
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

[mysql]
default-character-set = utf8mb4
EOF'

 echo $passwrd | sudo -S service mysql restart
 touch "$MARKER_FILE"
fi
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install 18
echo $passwrd | sudo -S NEEDRESTART_MODE=a apt install npm -y
echo $passwrd | sudo -S npm install -g yarn
echo $passwrd | sudo -S pip3 install frappe-bench
bench init --frappe-branch version-15 frappe-bench
cd frappe-bench/
chmod -R o+rx /home/$USER/
bench get-app --resolve-deps https://github.com/abrefael/self_practice.git
bench new-site self_practice.local --db-root-password $sql_passwrd --admin-password $admin_pass --install-app self_practice
bench use self_practice.local
echo $passwrd | sudo -S sed -i -e 's/include:/include_tasks:/g' /usr/local/lib/python3.10/dist-packages/bench/playbooks/roles/mariadb/tasks/main.yml
yes | sudo bench setup production $USER
FILE="/etc/supervisor/supervisord.conf"
SEARCH_PATTERN="chown=$USER:$USER"
if grep -q "$SEARCH_PATTERN" "$FILE"; then
 echo $passwrd | sudo -S sed -i "/chown=.*/c $SEARCH_PATTERN" "$FILE"
else
 echo $passwrd | sudo -S sed -i "5a $SEARCH_PATTERN" "$FILE"
fi
echo $passwrd | sudo -S service supervisor restart
yes | sudo bench setup production $USER
bench scheduler enable
bench scheduler resume
bench setup socketio
yes | bench setup supervisor
bench setup redis
echo $passwrd | sudo -S supervisorctl reload
