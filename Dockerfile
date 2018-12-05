FROM jenkins/jenkins:lts

##PLUGINS
# Distributed Builds plugins
RUN /usr/local/bin/install-plugins.sh ssh-slaves
RUN /usr/local/bin/install-plugins.sh ssh
RUN /usr/local/bin/install-plugins.sh ssh-agent
RUN /usr/local/bin/install-plugins.sh ssh-credentials

# install Notifications and Publishing plugins
RUN /usr/local/bin/install-plugins.sh email-ext
RUN /usr/local/bin/install-plugins.sh mailer
RUN /usr/local/bin/install-plugins.sh slack

# Artifacts
RUN /usr/local/bin/install-plugins.sh htmlpublisher

# UI
RUN /usr/local/bin/install-plugins.sh greenballs
RUN /usr/local/bin/install-plugins.sh simple-theme-plugin

# Scaling
RUN /usr/local/bin/install-plugins.sh kubernetes

#Prometheus
RUN /usr/local/bin/install-plugins.sh prometheus

#RUBY
RUN /usr/local/bin/install-plugins.sh rvm
RUN /usr/local/bin/install-plugins.sh ruby-runtime

#RUNDECK
RUN /usr/local/bin/install-plugins.sh rundeck

#Docker
RUN /usr/local/bin/install-plugins.sh docker-build-step
RUN /usr/local/bin/install-plugins.sh docker-commons
RUN /usr/local/bin/install-plugins.sh docker-compose-build-step
RUN /usr/local/bin/install-plugins.sh docker-custom-build-environment
RUN /usr/local/bin/install-plugins.sh docker-plugin
RUN /usr/local/bin/install-plugins.sh docker-slaves
RUN /usr/local/bin/install-plugins.sh docker-traceability
RUN /usr/local/bin/install-plugins.sh docker-workflow

#Google
RUN /usr/local/bin/install-plugins.sh google-cloudbuild
RUN /usr/local/bin/install-plugins.sh google-compute-engine
RUN /usr/local/bin/install-plugins.sh google-container-registry-auth
RUN /usr/local/bin/install-plugins.sh google-login
RUN /usr/local/bin/install-plugins.sh google-oauth-plugin

#Role strategy
RUN /usr/local/bin/install-plugins.sh role-strategy

#Pipeline
RUN /usr/local/bin/install-plugins.sh convert-to-pipeline
RUN /usr/local/bin/install-plugins.sh workflow-aggregator
RUN /usr/local/bin/install-plugins.sh blueocean-pipeline-editor
RUN /usr/local/bin/install-plugins.sh hubot-steps
RUN /usr/local/bin/install-plugins.sh pipeline-model-definition

# if we want to install via apt
USER root
RUN apt-get update && \
	apt-get install -y git \
	ruby \
	make \
	openssh-server \
	vim \
	apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common && \
	curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
	add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable" && \
	apt-get update && \
	apt-get -y install docker-ce

#DOCKER
RUN apt-get install -y docker-ce

RUN usermod -a -G docker jenkins

#CAPISTRANO
RUN gem install capistrano -v3.4.0
RUN gem install capistrano-passenger
RUN cap --version

#RANCHER-COMPOSE (based on concept by jeefy/install-rancher-compose.sh)
ENV VERSION_NUM="0.12.5"
RUN wget https://github.com/rancher/rancher-compose/releases/download/v${VERSION_NUM}/rancher-compose-linux-amd64-v${VERSION_NUM}.tar.gz
RUN tar zxf rancher-compose-linux-amd64-v${VERSION_NUM}.tar.gz
RUN rm rancher-compose-linux-amd64-v${VERSION_NUM}.tar.gz
RUN sudo mv rancher-compose-v${VERSION_NUM}/rancher-compose /usr/local/bin/rancher-compose
RUN sudo chmod +x /usr/local/bin/rancher-compose
RUN rm -r rancher-compose-v${VERSION_NUM}

USER jenkins
RUN ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N ''
# COPY ./ssh/id_rsa /root/.ssh/id_rsa 
# COPY ./ssh/id_rsa.pub /root/.ssh/id_rsa.pub
# RUN eval "$(ssh-agent -s)"
# RUN git config --global user.email "sistemas@i-med.cl"
# RUN git config --global user.name "Jenkins"
#RUN ssh-add
