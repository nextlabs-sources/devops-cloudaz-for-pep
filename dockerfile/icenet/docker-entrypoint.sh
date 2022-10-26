#!/bin/bash
set -e
#/etc/init.d/CompliantEnterpriseServer "$@"
# echo cc > /etc/hostname - Pass when running container

touch /etc/init.d/ControlCenterES
mv /usr/local/PolicyServer/icenet_properties.json /usr/local/PolicyServer/cc_properties.json 
/usr/local/PolicyServer/install.sh -s

#sed -i "s/:443/:8080/g" "/opt/nextlabs/PolicyServer/server/configuration/cc-console-app.properties"

# License
# /opt/nextlabs/PolicyServer/java/bin/java -jar /opt/nextlabs/PolicyServer/tools/crypt/crypt.jar -w '{"license_info":{"expiry_date":"05/11/2020","subcription_mode":"trial"},"pdp_info":[{"id":1,"host":"poc-jpc0","memory":"2048MB","vcpu":1},{"id":2,"host":"poc-jpc1","memory":"2048MB","vcpu":1}]}' > /opt/nextlabs/PolicyServer/server/license/sys_info.dat



unzip -o -q /tmp/Oauth2JWTSecret-Plugin.zip -d /tmp/Oauth2JWTSecret-Plugin
mkdir -p /opt/nextlabs/PolicyServer/server/plugins/jar /opt/nextlabs/PolicyServer/server/plugins/config
find "/tmp/Oauth2JWTSecret-Plugin/Control Center" -type f -name "*.properties" -exec cp "{}" /opt/nextlabs/PolicyServer/server/plugins/config \;
find "/tmp/Oauth2JWTSecret-Plugin/Control Center" -type f -name "*.jar" -exec cp "{}" /opt/nextlabs/PolicyServer/server/plugins/jar/ \;
rm -rf /tmp/Oauth2JWTSecret-Plugin.zip /tmp/Oauth2JWTSecret-Plugin

# fix to avoid port conflict 
cp  /opt/nextlabs/PolicyServer/java/jre/lib/rt.jar  /opt/nextlabs/PolicyServer/java/jre/lib/rt.jar-bak
find /opt/nextlabs/PolicyServer/java/jre/lib/rt.jar -type f -exec sed -i 's/8889/7779/g' {} \;

# Copy CC certs from below direcroty to ICENET cert directory
yes | cp -rf /tmp/cc-certs/* /opt/nextlabs/PolicyServer/server/certificates/

cd /opt/nextlabs/PolicyServer/server/certificates
chown nextlabs:nextlabs *

# remove license key
rm /usr/local/license.dat

sed -i "s/Requires=ControlCenterES.service/#Requires=ControlCenterES.service/g"  "/etc/systemd/system/CompliantEnterpriseServer.service"
systemctl daemon-reload
/opt/nextlabs/PolicyServer/start-policy-server.sh