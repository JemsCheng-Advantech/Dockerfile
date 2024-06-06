#Assign image to use
#FROM advrisc/u20.04-rklbv1 
FROM advrisc/u20.04-rklbv1

#Maintainer Info
MAINTAINER adv

#Run commands
RUN sudo apt-get update -y
RUN sudo apt install gawk wget git diffstat unzip texinfo gcc build-essential \
	chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils \
	iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev \
	python3-subunit mesa-common-dev zstd liblz4-tool file locales -y

RUN git config --global user.name "Your Name"
RUN git config --global user.email you@example.com

RUN sudo apt-get install libcurl4-openssl-dev tk gettext -y
RUN sudo apt-get install autoconf git make -y

RUN wget https://github.com/git/git/archive/v2.32.0.tar.gz
RUN tar zxvf v2.32.0.tar.gz
#RUN cd git-2.32.0

WORKDIR git-2.32.0

RUN make ./configure
RUN ./configure --prefix=/usr
RUN sudo apt-get install asciidoc -y
RUN make all doc
RUN sudo make install install-doc install-html

WORKDIR /home/adv
#USER adv
RUN rm -rf git-2.32.0 v2.32.0.tar.gz

#ENV HOME /home/adv
#SHELL ["/bin/sh", "-c"]
#RUN mkdir bin/aaa
RUN curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > bin/repo


RUN export GIT_SSL_NO_VERIFY=1 && \
	git config --global http.sslverify false && \
	git config --global url."https://".insteadOf git://

#RUN mkdir adv-release-bsp
#RUN mkdir test


#CMD ["-v", "/dev:/dev", "-v", "/lib/modules:/lib/modules", "-v","/usr/src:/usr/src", "/bin/bash"]
