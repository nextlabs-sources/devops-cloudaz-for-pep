FROM centos:7.6.1810
LABEL Maintainer="Nextlabs"

ARG HOSTNAME=${HOSTNAME}


RUN yum install libcap-devel -y && \
    yum clean all 

RUN ln -sf /usr/share/zoneinfo/PST8PDT /etc/localtime 


RUN AWS_ACCESS_KEY_ID=AKIAIHIMVFRHPGPZPFGQ \
    AWS_SECRET_ACCESS_KEY=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 \
    aws s3 cp s3://nxtlbsrelease/Platform_SAAS/license.dat /usr/local/license.dat

# DOWNLAOD CHEF LINUX INSTALLER - CAN BE TUNED TO PASS VERSION NUMBER

RUN AWS_ACCESS_KEY_ID=AKIAIHIMVFRHPGPZPFGQ \
    AWS_SECRET_ACCESS_KEY=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 \
    aws s3 cp s3://nxtlbsrelease/Platform_SAAS/cc/ControlCenter-Linux-chef-8.7.2.0-13.zip /tmp/ControlCenter.zip 
    
RUN unzip /tmp/ControlCenter.zip -d /usr/local
RUN chmod +x /usr/local/PolicyServer/install.sh 

COPY icenet_properties.json /usr/local/PolicyServer/


RUN AWS_ACCESS_KEY_ID=AKIAIHIMVFRHPGPZPFGQ AWS_SECRET_ACCESS_KEY=/cmZ1lJNt7vQDd70NL2BqEM8L5EdVshYP5l+h8ey \
    aws s3 cp s3://nxtlbsrelease/Platform_SAAS/sample_files/sample_policy.bin /opt/nextlabs/PolicyServer/server/resources/help/ 

# oauth Plugin Setup
RUN AWS_ACCESS_KEY_ID=AKIAIHIMVFRHPGPZPFGQ \
    AWS_SECRET_ACCESS_KEY=/cmZ1lJNt7vQDd70NL2BqEM8L5EdVshYP5l+h8ey \
    aws s3 cp s3://nxtlbsrelease/Platform_SAAS/Oauth2JWTSecret_Plugin/Oauth2JWTSecret-Plugin-8.1.2.zip /tmp/Oauth2JWTSecret-Plugin.zip


# logs was missing - installer was  unable to create catalina.out 
RUN mkdir -p /opt/nextlabs/PolicyServer/server/tomcat/logs

# Delete extracted policy server after installation complete

# add nextlabs user to sudoers list
RUN echo "nextlabs ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers


#RUN rm -rf /tmp/ControlCenter.zip


#COPY CompliantEnterpriseServer /tmp/CompliantEnterpriseServer


COPY docker-entrypoint.sh /tmp/docker-entrypoint.sh
RUN chmod +x /tmp/docker-entrypoint.sh

CMD /tmp/docker-entrypoint.sh ; sleep infinity