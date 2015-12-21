#Đây là cách đơn giản nhất là dùng luôn centos 7
#FROM centos:7

#Có thể tạo một images như trên trang docker là tạo một images khác tên là local/c7-systemd (Dùng file Dockerfile-base )
FROM local/c7-systemd

# Install common tools #########

RUN yum -y update; yum clean all;
RUN yum -y install epel-release; yum clean all;

RUN echo %sudo ALL=NOPASSWD: ALL >> /etc/sudoers
RUN yum install -y gcc make git

RUN yum install -y vim wget htop ntpdate telnet unzip
#RUN timedatectl set-timezone Asia/Ho_Chi_Minh
RUN /sbin/ntpdate pool.ntp.org

# Install nginx ###########

RUN yum -y install nginx; yum clean all; systemctl enable nginx; rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm; rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm 

ADD ./nginx/nginx.conf /etc/nginx/
ADD ./nginx/vhosts/* /etc/nginx/conf.d/

# Install php ###########

RUN yum --enablerepo=remi,remi-php56 install -y php-pecl-zip php-xml php-pecl-igbinary php-phalcon php-pecl-memcache \
                php-pecl-mongo php-pecl-xdebug php-pecl-jsonc php-cli php-pdo php-pear \
                php-pecl-jsonc-devel php-intl php-pecl-redis php-pecl-xhprof php-mysqlnd \
                php php-mbstring php-xcache php-gd php-fpm php-common php-process php-devel \
                php-pecl-gearman php-xmlrpc php-mcrypt php-soap php-pecl-xhprof pcre-devel

ADD ./php/php.ini /etc/
ADD ./php/www.conf /etc/php-fpm.d/

RUN systemctl enable php-fpm

RUN chown -R nginx:nginx /var/lib/php/session/


# Install npm ###########

RUN yum install -y npm
RUN npm install -g bower grunt-cli

# Install phalcon
RUN git clone git://github.com/phalcon/cphalcon.git /home/install/cphalcon
RUN cd /home/install/cphalcon/build && ./install

RUN rm -rf /var/lib/php/session/
RUN mkdir /var/lib/php/session/
RUN chown -R nginx:nginx /var/lib/php/session/
RUN chmod -R 777 /var/lib/php/session/
RUN useradd foo
VOLUME /tiki/www/tala
EXPOSE 80
CMD ["/usr/sbin/init"]
