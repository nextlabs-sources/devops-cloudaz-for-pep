#!/bin/bash

find /opt/Nextlabs/PolicyServer/ -type f -exec  sed -i 's/dc.serviceops.cloudaz.net/dcc.serviceops.cloudaz.net/g' {} +

cd /opt/Nextlabs/PolicyServer/server/logs
rm -rf *

cd /opt/Nextlabs/PolicyServer/server/certificates
# backup the old certs
mv web-keystore.jks web-keystore.jks-bak
mv web-truststore.jks web-truststore.jks-bak
mv web.cer web.cer-bak

/opt/Nextlabs/PolicyServer/java/bin/keytool -genkey -dname "cn=dcc.serviceops.cloudaz.net" -alias secWeb -keypass NextNext2019! -storepass NextNext2019! -keyalg RSA -keystore web-keystore.jks
/opt/Nextlabs/PolicyServer/java/bin/keytool -export -alias secWeb -keypass NextNext2019! -storepass NextNext2019! -keystore web-keystore.jks -file web.cer
/opt/Nextlabs/PolicyServer/java/bin/keytool -noprompt -import -alias secWeb -keypass NextNext2019! -storepass NextNext2019! -keystore web-truststore.jks -file web.cer

chown -R nextlabs:nextlabs /opt/Nextlabs/PolicyServer/server/certificates/*
chmod -R 0755 /opt/Nextlabs/PolicyServer/server/certificates/*

export JAVA_HOME=/opt/Nextlabs/PolicyServer/java/jre
export JRE_HOME=/opt/Nextlabs/PolicyServer/java/jre
export CATALINA_HOME=/opt/Nextlabs/PolicyServer/server/tomcat
export CATALINA_TMP=/opt/Nextlabs/PolicyServer/server/tomcat/temp
export CATALINA_BASE=/opt/Nextlabs/PolicyServer/server/tomcat
export CATALINA_PID=/opt/Nextlabs/PolicyServer/CompliantEnterpriseServer-daemon.pid
export TOMCAT_USER=nextlabs
export SERVER_XML=/opt/Nextlabs/PolicyServer/server/configuration/server.xml
export JAVA_ENDORSED_DIRS=/opt/Nextlabs/PolicyServer/server/tomcat/common/endorsed
export CLASSPATH=/opt/Nextlabs/PolicyServer/server/tomcat/shared/lib/nxl-filehandler.jar

export JAVA_OPTS="-Xmx2048m -Xms1024m -XX:MaxPermSize=512M -Dsun.lang.ClassLoader.allowArraySyntax=true -Xverify:none -Dorg.apache.commons.logging.Log=org.apache.commons.logging.impl.Jdk14Logger -Dserver.config.path=/opt/Nextlabs/PolicyServer/server/configuration -Dcc.home=/opt/Nextlabs/PolicyServer -Dserver.hostname=dcc.serviceops.cloudaz.net -Dserver.name=https://dcc.serviceops.cloudaz.net:443 -Dconsole.install.mode=OPN  -Dlog4j.configurationFile=/opt/Nextlabs/PolicyServer/server/configuration/log4j2.xml -Dlogging.config=file:/opt/Nextlabs/PolicyServer/server/configuration/log4j2.xml -Dorg.springframework.boot.logging.LoggingSystem=none -Dspring.cloud.bootstrap.location=/opt/Nextlabs/PolicyServer/server/configuration/bootstrap.properties -Djdk.tls.rejectClientInitiatedRenegotiation=true"

# start the service

/opt/Nextlabs/PolicyServer/java/jre/bin/java -Djava.util.logging.config.file=/opt/Nextlabs/PolicyServer/server/tomcat/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Xmx2048m -Xms1024m -XX:MaxPermSize=512M -Dsun.lang.ClassLoader.allowArraySyntax=true -Xverify:none -Dorg.apache.commons.logging.Log=org.apache.commons.logging.impl.Jdk14Logger -Dserver.config.path=/opt/Nextlabs/PolicyServer/server/configuration -Dcc.home=/opt/Nextlabs/PolicyServer -Dserver.hostname=dcc.serviceops.cloudaz.net -Dserver.name=https://dcc.serviceops.cloudaz.net -Dconsole.install.mode=OPN -Dlog4j.configurationFile=/opt/Nextlabs/PolicyServer/server/configuration/log4j2.xml -Dlogging.config=file:/opt/Nextlabs/PolicyServer/server/configuration/log4j2.xml -Dorg.springframework.boot.logging.LoggingSystem=none -Dspring.cloud.bootstrap.location=/opt/Nextlabs/PolicyServer/server/configuration/bootstrap.properties -Djdk.tls.rejectClientInitiatedRenegotiation=true -Djdk.tls.ephemeralDHKeySize=2048 -Djava.protocol.handler.pkgs=org.apache.catalina.webresources -Dorg.apache.catalina.security.SecurityListener.UMASK=0027 -Djava.endorsed.dirs=/opt/Nextlabs/PolicyServer/server/tomcat/common/endorsed -classpath /opt/Nextlabs/PolicyServer/server/tomcat/shared/lib/nxl-filehandler.jar:/opt/Nextlabs/PolicyServer/server/tomcat/bin/bootstrap.jar:/opt/Nextlabs/PolicyServer/server/tomcat/bin/tomcat-juli.jar -Dcatalina.base=/opt/Nextlabs/PolicyServer/server/tomcat -Dcatalina.home=/opt/Nextlabs/PolicyServer/server/tomcat -Djava.io.tmpdir=/opt/Nextlabs/PolicyServer/server/tomcat/temp org.apache.catalina.startup.Bootstrap -config /opt/Nextlabs/PolicyServer/server/configuration/server.xml start


