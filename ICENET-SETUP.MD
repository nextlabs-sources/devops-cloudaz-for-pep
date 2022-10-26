f1cb7c7d58b7 = centos 7.6.1810 image

docker must have "libcap-devel"

yum install libcap-devel -y && yum install unzip -y && yum install telnet -y
    
docker run -d  -p 6443:6443 -v /tmp:/tmp --hostname icenet --link cc:cc --link gifted_benz:db --privileged --name=icenet f1cb7c7d58b7  /usr/sbin/init;sleep infinity 



# make sure certs are copied from cc and available in /tmp folder

/also bootstrap.properties from configuration fodler
and
PolicyServer/java/jre/lib/security/rootca to same folder in icenet

# COPy certs and required config files from CC 
# remember to copy above files to ICENET location before starting icenet

/bin/cp /tmp/cc-certificates/bootstrap.properties /opt/Nextlabs/PolicyServer/server/configuration/bootstrap.properties
/bin/cp /tmp/cc-certificates/* /opt/Nextlabs/PolicyServer/server/certificates/ 
/bin/cp /tmp/cc-certificates/cacerts /opt/Nextlabs/PolicyServer/java/jre/lib/security/ 

chown -R nextlabs:nextlabs /opt/Nextlabs/PolicyServer/server/configuration/bootstrap.properties
chown -R nextlabs:nextlabs /opt/Nextlabs/PolicyServer/server/certificates/*
chown -R nextlabs:nextlabs /opt/Nextlabs/PolicyServer/java/jre/lib/security/cacerts


# to by pass service (systemd for docker)
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

export JAVA_OPTS="-Xmx2048m -Xms1024m -XX:MaxPermSize=512M -Dsun.lang.ClassLoader.allowArraySyntax=true -Xverify:none -Dorg.apache.commons.logging.Log=org.apache.commons.logging.impl.Jdk14Logger -Dserver.config.path=/opt/Nextlabs/PolicyServer/server/configuration -Dcc.home=/opt/Nextlabs/PolicyServer -Dserver.hostname=icenet -Dserver.name=https://icenet -Dconsole.install.mode=OPN  -Dlog4j.configurationFile=/opt/Nextlabs/PolicyServer/server/configuration/log4j2.xml -Dlogging.config=file:/opt/Nextlabs/PolicyServer/server/configuration/log4j2.xml -Dorg.springframework.boot.logging.LoggingSystem=none -Dspring.cloud.bootstrap.location=/opt/Nextlabs/PolicyServer/server/configuration/bootstrap.properties -Djdk.tls.rejectClientInitiatedRenegotiation=true"




# start service

/opt/Nextlabs/PolicyServer/server/tomcat/bin/startup.sh -config "/opt/Nextlabs/PolicyServer/server/configuration/server.xml"



