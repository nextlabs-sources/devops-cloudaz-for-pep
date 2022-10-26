# rememebr jpc must be crunning on host network mode
docker run --add-host=icenet:127.0.0.1 -d   -v /tmp:/tmp --hostname jpc.serviceops.cloudaz.net  --net host  --privileged --name=jpc f1cb7c7d58b7  /usr/sbin/init;sleep infinity

NO NEED PORT MAPPING since we use host port


# Steps to install java - adopt
https://adoptopenjdk.net/installation.html#x64_linux-jre

cp -a /tmp/jdk8u232-b09-jre /opt/
cd /opt/
export PATH=$PWD/jdk8u232-b09-jre/bin:$PATH
java -version
# Set java home
export JAVA_HOME=/opt/jdk8u232-b09-jre


# make sure local host has /tmp/apache-tomcat-8.5.45.zip
yum install unzip -y 
unzip /tmp/apache-tomcat-8.5.45.zip -d /usr/share/tomcat8/ 
cd /usr/share/tomcat8/
mv /usr/share/tomcat8/apache-tomcat-8.5.45/* .
rm -rf apache-tomcat-8.5.45/

# set catalina home
export CATALINA_HOME=/usr/share/tomcat8



groupadd tomcat
useradd -M -s /bin/nologin -g tomcat -d /usr/share/tomcat8 tomcat
chown -R tomcat /usr/share/tomcat8
chmod +x /usr/share/tomcat8/bin/*.sh
chmod -R g+r /usr/share/tomcat8/conf
chown -R tomcat /usr/share/tomcat8/webapps/ /usr/share/tomcat8/work/ /usr/share/tomcat8/temp/ /usr/share/tomcat8/logs/
mkdir -p /usr/share/tomcat8/nextlabs
unzip -o -q /tmp/Oauth2JWTSecret-Plugin.zip -d /tmp/Oauth2JWTSecret-Plugin
chmod +x /tmp/Policy_Controller_Java/install.sh

# make sure to copy jpc_properires file

/tmp/Policy_Controller_Java/install.sh -s


# start tomcat
cd /usr/share/tomcat8/bin
./catalina.sh start


# to check logs
go to 
/usr/share/tomcat8/nextlabs/dpc/logs

you should see somethign like below

pa5_activity.log0  pass_activity.log0  trk3_activity.log0


