# Jenkins-Master docker image

## Description
Jenkins Master containing Docker daemon. You can manage plugins from plugins.txt file.
Simply add \<plugin_name\>:\<plugin_version\> before the build to add this plugin to jenkins.
Available plugins can be found in https://updates.jenkins-ci.org/download/plugins/


## How to use this image

### Build image from git interne
    sudo docker build https://github.com/lixtec/docker-img-jenkins.git -t lixtec/jenkins-master:1.0.0
    

### run image
    sudo docker run -d \
    -p 8080:8080 \
    -p 50000:50000 \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    -v infra-jenmas-app:/var/jenkins_home \
    --privileged \
    --name jenkins-master lixtec/jenkins-master:1.0.0

## Technical datas
### Exposed volumes

    VOLUME [/var/jenkins_home, /var/run/docker.sock]
    
### Exposed ports

    :8080 - accès applicatif
    :50000 - JNLP port (allow a slave to connect to the master instance)

### Environment Variables

sans objet