#!/bin/bash
set -e


export CATALINA_HOME=/usr/share/tomcat8
# below line is present in cloud-init not working in VM version  too tomcat8.conf NOT found error
# echo CATALINA_OPTS=\"-Dnextlabs.dont.care.acceptable=true -Dnextlabs.error.result.acceptable=true -Djava.rmi.server.hostname=jpc.serviceops.cloudaz.net\" >> /etc/tomcat8/tomcat8.conf

/usr/local/Policy_Controller_Java/install.sh -s


sed -i "s|jar-path.*|jar-path = /usr/share/tomcat8/nextlabs/dpc/jservice/jar/$(basename "$(find '/tmp/Oauth2JWTSecret-Plugin/Policy Controller' -type f -name *.jar)")|" "$(find '/tmp/Oauth2JWTSecret-Plugin/Policy Controller' -type f -name *.properties)"
find "/tmp/Oauth2JWTSecret-Plugin/Policy Controller" -type f -name "*.properties" -exec cp "{}" /usr/share/tomcat8/nextlabs/dpc/jservice/config/ \;
find "/tmp/Oauth2JWTSecret-Plugin/Policy Controller" -type f -name "*.jar" -exec cp "{}" /usr/share/tomcat8/nextlabs/dpc/jservice/jar/ \;

# shutdown port change to enable single vm deployment
find /usr/share/tomcat8/conf/server.xml -type f -exec sed -i 's/8005/8115/g' {} \;

/usr/share/tomcat8/bin/catalina.sh start
