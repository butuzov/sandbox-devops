FROM centos:7

ENV container docker

RUN yum -y update && yum clean all
RUN yum -y install initscripts httpd links systemd python-setuptools cronie
RUN easy_install supervisor

RUN touch /etc/cron.d/hello-cron \
	&& echo '* * * * * root echo "Hello world" >> /var/log/cron.log 2>&1' > /etc/cron.d/hello-cron

# RUN echo 'root:passw0rd' | chpasswd

COPY httpd.conf     /etc/httpd/conf/

EXPOSE 8080

COPY supervisord.conf /etc/supervisor/supervisord.conf
CMD ["/usr/bin/supervisord"]


