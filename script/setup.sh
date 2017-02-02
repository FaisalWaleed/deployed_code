# ssh machine -i ~/.ssh/key -l root 'cat >>.ssh/authorized_keys' < ~/.ssh/botly.pub
# CREATE DATABASE botly;
# CREATE USER 'botly' identified by 'botlyPassword';
# GRANT ALL PRIVILEGES ON botly.* TO 'botly';
# FLUSH PRIVILEGES;
useradd -U -s /bin/bash -G sudo -d /home/botly botly
mkdir -p /home/botly
mkdir -p /home/botly/.ssh
cp ~/.ssh/authorized_keys /home/botly/.ssh
chown -R botly:botly /home/botly

echo '%sudo ALL=(ALL:ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/nopasswd-for-sudo-group
chmod 0440 /etc/sudoers.d/nopasswd-for-sudo-group

######################
# Log in as botly user #
######################
echo 'Log in as botly user and set hostname'
exit 0

echo $SERVER | sudo tee /etc/hostname
sudo sed -i "s#localhost#localhost `cat /etc/hostname`#" /etc/hosts
sudo hostname `cat /etc/hostname`

# required installs
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo -E apt-get -q -y install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev mysql-client libmysqlclient-dev nginx nodejs vim-nox tmux htop

cd
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exec $SHELL

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL

sh <(curl https://j.mp/spf13-vim3 -L)
cat <<EOF >> ~/.bash_profile
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
EOF
exec $SHELL

sudo mount -o remount,exec /tmp
sudo chmod a+rx /usr/bin/gcc-5
rbenv install 2.3.1
rbenv global 2.3.1
ruby -v
gem install bundler
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 22
sudo ufw allow 3306

#datebase setup
#export MYSQL_INSTALL=1
if [[ -n $MYSQL_INSTALL ]]; then
    export DEBIAN_FRONTEND=noninteractive
    echo "mysql-server mysql-server/root_password password root" | sudo debconf-set-selections
    echo "mysql-server mysql-server/root_password_again password root" | sudo debconf-set-selections
    sudo -E apt-get -q -y install mysql-server redis-server
    mysql_secure_installation --password=root -D
    sudo sed -i 's/127\.0\.0\.1/0\.0\.0\.0/g' /etc/mysql/my.cnf
    sudo sed -i 's/127\.0\.0\.1/0\.0\.0\.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf
    sudo sed -i 's/#max_connections        = 100/max_connections=500/g' /etc/mysql/mysql.conf.d/mysqld.cnf
    sudo service mysql restart
    mysql -uroot --password=root -e 'USE mysql; UPDATE `user` SET `Host`="%" WHERE `User`="root" AND `Host`="localhost"; DELETE FROM `user` WHERE `Host` != "%" AND `User`="root"; CREATE DATABASE botly; SET GLOBAL validate_password_policy="LOW"; CREATE USER "botly" identified by "botlyPassword"; GRANT ALL PRIVILEGES ON botly.* to "botly"; FLUSH PRIVILEGES;'

    # redis setup
    sudo sed -i "s/# requirepass foobared/requirepass `echo 'botly-test' | sha256sum | awk '{print $1}'`/g" /etc/redis/redis.conf
    sudo sed -i "s/bind 127.0.0.1//g" /etc/redis/redis.conf
    sudo service redis restart

    mysqladmin -u root --password=root password `echo "botly-server" | sha256sum | awk '{print $1}'`
fi

sudo ufw enable


# phantomjs
scp ~/Downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 $SERVER:~/
tar -xvf phantomjs-2.1.1-linux-x86_64.tar.bz2
sudo cp phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/bin/phantomjs
RAILS_ENV=production bundle exec resque-web -p 8282 lib/resque_web_init.rb
RAILS_ENV=production bundle exec rake resque:scheduler
RAILS_ENV=production bundle exec rails c
Resque.workers.each {|w| w.unregister_worker if w.processing['run_at'] && Time.now - w.processing['run_at'].to_time > 300}
