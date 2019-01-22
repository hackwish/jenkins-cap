FROM jenkins/jenkins:lts

COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy

ENV JENKINS_SLAVE_AGENT_PORT 50001

# ENV JAVA_OPTS=-Dhudson.footerURL=https://jenkins.test
# ENV JAVA_OPTS=-Djava.awt.headless=true
ENV JAVA_OPTS=-Djenkins.install.runSetupWizard=false
# ENV JAVA_OPTS=--argumentsRealm.passwd.admin=admin
# ENV JAVA_OPTS=--argumentsRealm.roles.user=admin
# ENV JAVA_OPTS=--argumentsRealm.roles.admin=admin

EXPOSE 8080
EXPOSE 50000
EXPOSE 50001

##PLUGINS
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# if we want to install via apt
USER root
RUN apt-get update && \
	apt-get install -y \
	git \
	ruby \
	make \
	openssh-server \
	vim \
	apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common


#ANSIBLE
RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list && \
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 && \
	apt-get update && \
	apt-get install -y ansible

#DOCKER
RUN curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
	add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable" && \
	apt-get update && \
	apt-get -y install docker-ce

#RUN groupadd docker
#RUN usermod -a -G docker $USER
RUN usermod -a -G docker jenkins

# #RUN chmod -R 777  /var/run/docker.sock

#CAPISTRANO
RUN gem install capistrano -v3.4.0
RUN gem install capistrano-passenger
RUN cap --version

#RANCHER-COMPOSE (based on concept by jeefy/install-rancher-compose.sh)
ENV VERSION_NUM="0.12.5"
RUN wget https://github.com/rancher/rancher-compose/releases/download/v${VERSION_NUM}/rancher-compose-linux-amd64-v${VERSION_NUM}.tar.gz
RUN tar zxf rancher-compose-linux-amd64-v${VERSION_NUM}.tar.gz
RUN rm rancher-compose-linux-amd64-v${VERSION_NUM}.tar.gz
RUN mv rancher-compose-v${VERSION_NUM}/rancher-compose /usr/local/bin/rancher-compose
RUN chmod +x /usr/local/bin/rancher-compose
RUN rm -r rancher-compose-v${VERSION_NUM}

# #LIMPIANDO
# RUN apt-get -y clean && \
# 	rm -rf /var/lib/apt/lists/*

USER jenkins
# RUN ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N ''

# COPY ./ssh/id_rsa /root/.ssh/id_rsa 
# COPY ./ssh/id_rsa.pub /root/.ssh/id_rsa.pub
# RUN eval "$(ssh-agent -s)"
# RUN git config --global user.email "sistemas@i-med.cl"
# RUN git config --global user.name "Jenkins"
#RUN ssh-add
