## This Dockerfile will download the bundled version of Ansible Core and Tower
## Be sure to disable Bubblewrap functionality in Tower if your Host OS is CentOS 7+

## Note, future version of Core/Tower will no longer support 16.04
FROM ubuntu:16.04

WORKDIR /opt

## Versions available here:
## https://releases.ansible.com/ansible-tower/setup-bundle/
## Feel free to switch versions around as you please
ENV container docker
ENV ANSIBLE_BUNDLE_VERSION 3.5.3-1.el7
ENV PG_DATA /var/lib/postgresql/9.6/main
ENV PROJECTS_DIR /var/lib/awx/PROJECTS_DIR
ENV DEBIAN_FRONTEND "noninteractive"
ENV LC_ALL "en_US.UTF-8"
ENV LANGUAGE "en_EN:en"
ENV LANG "en_US.UTF-8"

COPY inventory inventory
COPY init-tower.sh /init-tower.sh

## Get and download Tower 3.5.3, and Ansible Core 2.8.x
ADD https://releases.ansible.com/ansible-tower/setup-bundle/ansible-tower-setup-bundle-${ANSIBLE_BUNDLE_VERSION}.tar.gz ansible-tower-setup-bundle-${ANSIBLE_BUNDLE_VERSION}.tar.gz

## Update packages
RUN apt-get -qq update \
        && apt-get -yqq upgrade \
        && apt-get -yqq install \
                        locales \
                        gnupg2 \
                        gnupg \
                        libpython2.7 \
                        python \
                        python-pip \
                        ca-certificates \
                        debconf \
                        apt-transport-https \
                        sudo \
                        curl \
                        wget \               
        && locale-gen "en_US.UTF-8" \
        && echo "locales        locales/default_environment_locale      select  en_US.UTF-8" | debconf-set-selections \
        && dpkg-reconfigure locales
        
## Create log directory
RUN mkdir -p /var/log/tower        

## Extract bundled zip
RUN tar xvf ansible-tower-setup-bundle-${ANSIBLE_BUNDLE_VERSION}.tar.gz \
    && rm -f ansible-tower-setup-bundle-${ANSIBLE_BUNDLE_VERSION}.tar.gz \
    && mv inventory ansible-tower-setup-bundle-${ANSIBLE_BUNDLE_VERSION}/inventory

RUN cd /opt/ansible-tower-setup-bundle-${ANSIBLE_BUNDLE_VERSION} \
    && ./setup.sh \
    && chmod +x /init-tower.sh

## Expose these volumes to the container for mounting
VOLUME ["/sys/fs/cgroup", "${PG_DATA}", "${PROJECTS_DIR}", "/license_and_certs"]
EXPOSE 443

CMD ["/init-tower.sh"]
