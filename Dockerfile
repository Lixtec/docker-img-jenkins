ARG JENKINS_VERSION=2.176.2
ARG VERSION_DOCKER=17.06.2~ce-0~debian
FROM jenkins/jenkins:${JENKINS_VERSION}

MAINTAINER ludovic.terral@lixtec.fr

USER root

ENV JENKINS_VERSION=${JENKINS_VERSION:-2.138.2} 
ENV VERSION_DOCKER=${VERSION_DOCKER:-17.06.2~ce-0~debian}
RUN echo "version jenkins: $JENKINS_VERSION"
RUN echo "version docker: $VERSION_DOCKER"

RUN apt update -y  && apt-get install -y nano curl sshpass software-properties-common apt-transport-https &&\
    curl -kfsSL https://download.docker.com/linux/debian/gpg |  apt-key add - &&\
    apt-key fingerprint 0EBFCD88 &&\
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
RUN update-ca-certificates && apt -y full-upgrade && apt-get update -y &&\
    apt-get -y install apt-transport-https docker-ce=${VERSION_DOCKER} && apt -y autoremove 
RUN apt-mark hold 'docker-ce'

RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 2667CA5C
RUN echo "deb http://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt all main" >> /etc/apt/sources.list  &&\ 
    apt update -y && apt install -y firefox-mozilla-build 

RUN apt-get clean


COPY plugins/plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt
#RUN usermod -aG docker jenkins
#USER jenkins
