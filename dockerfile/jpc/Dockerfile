FROM centos:7.6.1810
LABEL Maintainer="Nextlabs"

ARG HOSTNAME=${HOSTNAME}


RUN yum install unzip -y && \
    yum install awscli -y && \
    yum install awscli -y && \
    yum install openssl-devel -y && \
    yum install mod_ssl -y && \
    yum install sudo -y && \
    yum install java-1.8.0-openjdk -y && \
    yum clean all 

RUN ln -sf /usr/share/zoneinfo/PST8PDT /etc/localtime 
# DOWNLOAD TOMCAT INSTALLATION PACKAGE
COPY apache-tomcat-8.5.45.zip /tmp/apache-tomcat-8.5.45.zip

RUN unzip /tmp/apache-tomcat-8.5.45.zip -d /usr/share/tomcat8/ 
RUN groupadd tomcat
RUN useradd -M -s /bin/nologin -g tomcat -d /usr/share/tomcat8 tomcat
RUN chown -R tomcat /usr/share/tomcat8
RUN chmod +x /usr/share/tomcat8/bin/*.sh
RUN chmod -R g+r /usr/share/tomcat8/conf
RUN chmod -R g+r /usr/share/tomcat8/conf
RUN chown -R tomcat /usr/share/tomcat8/webapps/ /usr/share/tomcat8/work/ /usr/share/tomcat8/temp/ /usr/share/tomcat8/logs/

#RUN mv /usr/share/tomcat8/PolicyControllerJava/* /usr/share/tomcat8/
#RUN rm -rf /usr/share/tomcat8/PolicyControllerJava
   
# DOWNLAOD CHEF LINUX INSTALLER - CAN BE TUNED TO PASS VERSION NUMBER
RUN AWS_ACCESS_KEY_ID=AKIAIHIMVFRHPGPZPFGQ \
    AWS_SECRET_ACCESS_KEY=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 \
    aws s3 cp s3://nxtlbsrelease/Platform_SAAS/jpc/PolicyControllerJava-chef-8.7.2.0-13.zip /tmp/PolicyControllerJava.zip

RUN unzip -o -q /tmp/PolicyControllerJava.zip -d /usr/local
RUN chmod +x /usr/local/Policy_Controller_Java/install.sh
RUN mkdir -p /usr/share/tomcat8/nextlabs
COPY jpc_properties.json /usr/local/Policy_Controller_Java/

RUN AWS_ACCESS_KEY_ID=AKIAIHIMVFRHPGPZPFGQ \
    AWS_SECRET_ACCESS_KEY=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 \
    aws s3 cp s3://nxtlbsrelease/Platform_SAAS/Oauth2JWTSecret_Plugin/Oauth2JWTSecret-Plugin-8.1.2.zip /tmp/Oauth2JWTSecret-Plugin.zip

RUN unzip -o -q /tmp/Oauth2JWTSecret-Plugin.zip -d /tmp/Oauth2JWTSecret-Plugin


# Delete extracted policy server after installation complete
# Remove installation files.

COPY docker-entrypoint.sh /tmp/docker-entrypoint.sh
RUN chmod +x /tmp/docker-entrypoint.sh

#EXPOSE 8080 58443 58080

CMD /tmp/docker-entrypoint.sh ; sleep infinity
