#!/bin/bash
##name: lior cohen
##date: 27/04/18
##decription: automate lamp installer

#tmp directory
tmp=`pwd`/tmp/

#install and configure functions

#start and enable the service
start_service() {
systemctl restart $1
systemctl enable $1
}

#install apache|httpd

install_apache2() {
echo "cp /tmp/httpd.conf $httpdir/conf.d/"
$package install $apache2
cp `pwd`/cgi-enabled.conf $httpdir/
start_service $apache2
}

#install nginx
install_nginx() {
echo "$package install -y $nginx"
start_service $nginx
}

install_mysql() {
$package install -y $mysql
start_service $mysql
}

#install_sqlite() {
#$package install -y $sqlite
#start_service $sqlite
#}

install_mariadb() {
$package install -y $mariadb
start_service $mariadb
}

install_php() {
$package install -y $php
cp "$tmp"index.php $appdir
index-index.php
}

install_perl() {
$package install -y $perl
cp "$tmp"index.cgi $appdir
chmod 705 "$appdir"index.cgi
index=index.cgi
}

install_python() {
$package install -y $python
cp "$tmp"index.py $appdir
chmod 705 $appdir"index.py"
index=index.py
}


#identifay the OS

OS=`cat /etc/*-release | grep -i id_like | awk -F= '{ print $2}'`


case $OS in
	*ubuntu*|*debian*)
		source `pwd`/debian.cfg
		read -p "which webserver would you like to install? (apache2|nginx)" webs
		install_$webs
		read -p "which DB would you like to install? (mariadb|mysql)" DB
		install_$DB
		read -p "which programming language would you like to install? (php|perl|python)" lang
		install_$lang
		;;
	*redhat*|*rhel*)
		source `pwd`/redhat.cfg
		read -p "which webserver would you like to install? (apache2|nginx)" webs
		install_$webs
		read -p "which DB would you like to install? (mariadb|mysql)" DB
		install_$DB
		read -p "which programming language would you like to install? (php|perl|python)" lang
		install_$lang
		;;
	*)
		echo "not supported"
		;;

esac

sleep 1
echo "every thing is set, go to your localhost/"$index""
