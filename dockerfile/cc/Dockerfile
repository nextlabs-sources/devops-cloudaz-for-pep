FROM centos:7.6.1810
LABEL Maintainer="Nextlabs"

ARG HOSTNAME=${HOSTNAME}

RUN yum install libcap-devel -y && \
    yum clean all && \
    ln -sf /usr/share/zoneinfo/PST8PDT /etc/localtime &&\
    AWS_ACCESS_KEY_ID=AKIAYNYEBS7YEQJ5SXFM \
    AWS_SECRET_ACCESS_KEY=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 \
    aws s3 cp s3://nxtlbsrelease/Platform_SAAS/license.dat /usr/local/license.dat && \
    aws s3 cp s3://nxtlbsrelease/Platform_SAAS/cc/ControlCenter-Linux-chef-9.2.0.0-15PS-Main.zip /tmp/ControlCenter.zip  && \
    unzip /tmp/ControlCenter.zip -d /usr/local && \
    chmod +x /usr/local/PolicyServer/install.sh && \
    aws s3 cp s3://nxtlbsrelease/Platform_SAAS/sample_files/sample_policy.bin /opt/nextlabs/PolicyServer/server/resources/help/ && \
    aws s3 cp s3://nxtlbsrelease/Platform_SAAS/Oauth2JWTSecret_Plugin/Oauth2JWTSecret-Plugin-8.1.2.zip /tmp/Oauth2JWTSecret-Plugin.zip &7 \
    mkdir -p /opt/nextlabs/PolicyServer/server/tomcat/logs && \
    echo "nextlabs ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    rm -rf /tmp/ControlCenter.zip

COPY cc_properties.json /usr/local/PolicyServer/  
COPY entrypoint.sh /tmp/entrypoint.sh

RUN chmod +x /tmp/entrypoint.sh

#CMD /tmp/entrypoint.sh ; sleep infinity
CMD  sleep infinity