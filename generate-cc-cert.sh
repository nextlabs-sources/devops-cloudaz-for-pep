#!/bin/bash

# generate 3 certificates
# web-keystore.jks ,web-truststore.jks , web.cer

# Below step is only required if you want to import your own ssl certificate  (for onpremise scenario)
# cd /opt/nextlabs/PolicyServer/java/bin/
# sudo ./keytool -import -alias secWeb -keypass variable('keystorepassword')-keystore /opt/nextlabs/PolicyServer/server/certificates/web-truststore.jks -storepass variable('keystorepassword')- -file /etc/nginx/server.crt

# to create new self signed certificates
cd /opt/Nextlabs/PolicyServer/server/certificates

mv web-keystore.jks web-keystore.jks-bak
mv web-truststore.jks web-truststore.jks-bak
mv web.cer web.cer-bak

/opt/Nextlabs/PolicyServer/java/bin/keytool -genkey -dname "cn=dc.serviceops.cloudaz.net" -alias secWeb -keypass NextNext2019! -storepass NextNext2019! -keyalg RSA -keystore web-keystore.jks
/opt/Nextlabs/PolicyServer/java/bin/keytool -export -alias secWeb -keypass NextNext2019! -storepass NextNext2019! -keystore web-keystore.jks -file web.cer
/opt/Nextlabs/PolicyServer/java/bin/keytool -noprompt -import -alias secWeb -keypass NextNext2019! -storepass NextNext2019! -keystore web-truststore.jks -file web.cer


/opt/Nextlabs/PolicyServer/java/bin/keytool -genkey -dname "cn=dc.serviceops.cloudaz.net" -alias dc.serviceops.cloudaz.net -keypass NextNext2019! -storepass NextNext2019! -keyalg RSA -keystore digital-signature-keystore.jks
/opt/Nextlabs/PolicyServer/java/bin/keytool -export -alias dc.serviceops.cloudaz.net -keypass NextNext2019! -storepass NextNext2019! -keystore  digital-signature-keystore.jks -file digital-signature.cer
/opt/Nextlabs/PolicyServer/java/bin/keytool -noprompt -import -alias dc.serviceops.cloudaz.net -keypass NextNext2019! -storepass NextNext2019! -keystore digital-signature-truststore.jks -file digital-signature.cer



chown -R nextlabs:nextlabs /opt/Nextlabs/PolicyServer/server/certificates/*
chmod -R 0755 /opt/Nextlabs/PolicyServer/server/certificates/*

# below step not required for 9.1
cd /opt/Nextlabs/PolicyServer/java/jre/lib/security/
/opt/Nextlabs/PolicyServer/java/bin/keytool -noprompt -delete -keystore cacerts -alias web -v
/opt/Nextlabs/PolicyServer/java/bin/keytool -noprompt -import -keystore cacerts -alias web -file /opt/Nextlabs/PolicyServer/server/certificates/web.cer

# to verify
/opt/Nextlabs/PolicyServer/java/bin/keytool -list -v -keystore web-truststore.jks
