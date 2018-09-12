ARG JENKINS_VERSION=2.121.3
ARG VERSION_DOCKER=17.06.2~ce-0~debian
FROM jenkins/jenkins:${JENKINS_VERSION}

MAINTAINER ludovic.terral@lixtec.fr

USER root

ENV JENKINS_VERSION=${JENKINS_VERSION:-2.121.3} 
ENV VERSION_DOCKER=${VERSION_DOCKER:-17.06.2~ce-0~debian}

RUN echo "version jenkins: $JENKINS_VERSION"
RUN echo "version docker: $VERSION_DOCKER"

RUN apt-get update -y && apt-get install -y nano curl software-properties-common apt-transport-https &&\
    curl -kfsSL https://download.docker.com/linux/debian/gpg |  apt-key add - &&\
    apt-key fingerprint 0EBFCD88 &&\
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

COPY ca/* /usr/local/share/ca-certificates/
RUN update-ca-certificates && apt -y full-upgrade && apt-get update -y &&\
    apt-get -y install apt-transport-https docker-ce=${VERSION_DOCKER} && apt -y autoremove 
RUN apt-mark hold 'docker-ce' && apt-get clean
ADD plugins/plugins.txt /usr/share/jenkins/plugins.txt
ADD add/plugins.sh /usr/local/bin/plugins.sh
ADD add/jenkins.sh /usr/local/bin/jenkins.sh
ADD add/entrypoint.sh /bin/jenkins.sh

RUN chmod +x /usr/local/bin/*.sh \
	&& chmod +x /bin/jenkins.sh

# Add wished plugins.
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

ENTRYPOINT ["/bin/jenkins.sh"]
