#! /bin/bash

echo "--> Updating CentOS System"
yum -y update

echo "--> Installing YUM modules"
sudo yum install -y \
zlib gd gd-devel \
libpng-devel libjpeg-devel libmng-devel \
mariadb-server mariadb \
perl-DBI perl-DBD-mysql \
epel-release \
perl-CPAN \
php php-mysql php-gd php-pear php-pear-DB php-pear-Date \
perl-Crypt-SSLeay perl-Template-Toolkit ImageMagick-perl perl-MIME-Lite \
libapreq2 libapreq2-devel perl-libapreq2 \
perl-libwww-perl \
ftp ntp \
screen \
pcre pcre-devel \
perl-Cache-Memcached \
perl-Apache-Session \
perl-YAML perl-JSON perl-JSON-XS perl-XML-LibXML perl-XML-Simple perl-XML-Parser \
php-imap \
perl-DateTime perl-Class-Accessor perl-Module-Build perl-HTML-FormatText-WithLinks \
libevent-devel \
memcached gcc \
perl-ExtUtils-Embed \
mod_perl mod_perl-devel ncurses-devel \
perl-YAML-Syck \
perl-App-cpanminus \

echo "--> Installing Perl modules with cpanm"
sudo cpanm \
Data::Serializer \
Cache::Memcached::Fast \
Apache::Session::Memcached \
Template::Alloy \
XML::SimpleObject \
XML::OPML \
XML::OPML::LibXML \
XML::OPML::SimpleGen \
XML::SimpleObject \
XML::Parser \
Data::Serializer \
Captcha::reCAPTCHA \
ModPerl::MM \
HTML::Tiny \
Date::Manip \
XML::FeedPP \
YAML::Parser::Syck \
Image::Size \

if ! sudo grep --quiet SSH_AUTH_SOCK /etc/sudoers; then
    echo "Keep SSH_AUTH_SOCK with sudo"
    echo "Defaults    env_keep+=SSH_AUTH_SOCK" | sudo tee -a /etc/sudoers
fi

git config --global user.email thaabit@gmail.com
git config --global user.name "Garth Hill"
echo "--> Git checkouts"
dir='~/dotfiles'
if [ ! -d $dir ]; then
    git clone git@github.com:thaabit/dotfiles.git $dir
fi
~/dotfiles/symlink.sh

dir='/root/dotfiles'
if ! sudo test -d $dir; then
    sudo git clone git@github.com:thaabit/dotfiles.git $dir
fi
sudo /root/dotfiles/symlink.sh

sudo chown thaabit.thaabit /var
dir='/var/jitsys'
if [ ! -d $dir ]; then
    git clone git@bitbucket.org:thaabit/jitsys.git $dir
fi

apache_conf='/etc/httpd/conf.d/jitsys.conf'
if ! sudo test -h $apache_conf; then
    sudo ln -s ~/dotfiles/jitsys.conf $apache_conf 2>&1
fi
