FROM jenkins/jenkins:lts
# if we want to install via apt
USER root
RUN apt-get update && apt-get install -y git ruby make openssh-server vim
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
