FROM jenkins/jenkins:lts
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

RUN apt-get install -y docker-ce

RUN usermod -a -G docker jenkins

RUN gem install capistrano -v3.4.0
RUN gem install capistrano-passenger
RUN cap --version

USER jenkins
RUN ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N ''
# COPY ./ssh/id_rsa /root/.ssh/id_rsa 
# COPY ./ssh/id_rsa.pub /root/.ssh/id_rsa.pub
# RUN eval "$(ssh-agent -s)"
# RUN git config --global user.email "sistemas@i-med.cl"
# RUN git config --global user.name "Jenkins"
#RUN ssh-add
