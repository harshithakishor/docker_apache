FROM centos:7

RUN yum -y update
RUN yum -y install httpd httpd-tools mod_ssl openssl expect

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
 && rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm

RUN yum --enablerepo=remi-php73 -y install php php-bcmath php-cli php-common php-gd php-intl php-ldap php-mbstring \
    php-mysqlnd php-pear php-soap php-xml php-xmlrpc php-zip
    
COPY ca.crt /etc/pki/tls/certs
COPY ca.key /etc/pki/tls/private/ca.key
COPY ca.csr /etc/pki/tls/private/ca.csr

RUN sed -E -i -e '/<Directory "\/var\/www\/html">/,/<\/Directory>/s/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf
RUN sed -E -i -e 's/DirectoryIndex (.*)$/DirectoryIndex index.php \1/g' /etc/httpd/conf/httpd.conf

ADD ssl.conf /etc/httpd/conf.d/ssl.conf

EXPOSE 80 443

CMD ["/usr/sbin/httpd","-D","FOREGROUND"]
