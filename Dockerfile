#Assign image to use
#FROM advrisc/u20.04-rklbv1
#FROM advrisc/u20.04-rklbv1     #Yocto 4.0
#FROM advrisc/u18.04-imx8lbv1   #Yocto 3.0
FROM advrisc/u18.04-imx8lbv1

#Maintainer Info
MAINTAINER adv

#Run commands
RUN sudo apt-get update -y
RUN sudo apt-get install gawk wget git diffstat unzip texinfo gcc build-essential\
	chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils\
	iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev\
	python3-subunit mesa-common-dev zstd liblz4-tool file locales -y

RUN git config --global user.name "Your Name"
RUN git config --global user.email you@example.com

RUN sudo apt-get install libcurl4-openssl-dev tk gettext -y
RUN sudo apt-get install autoconf git make -y

# Upgrade git
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


#Upgrade python
#RUN sudo apt-get install -y python-software-properties
RUN sudo apt-get autoremove -y
RUN sudo apt-get install -y software-properties-common
RUN sudo add-apt-repository -y ppa:deadsnakes/ppa
RUN sudo apt-get update
RUN sudo apt-get install -y python3.6
Run sudo rm /usr/bin/python3\
	&& sudo rm /usr/bin/python3m\
	&& sudo ln -s python3.6 /usr/bin/python3\
	&& sudo ln -s python3.6 /usr/bin/python3m


# Upgrade repo
#ENV HOME /home/adv
#SHELL ["/bin/sh", "-c"]
#RUN mkdir bin/aaa
RUN curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > bin/repo


RUN export GIT_SSL_NO_VERIFY=1\
	&& git config --global http.sslverify false\
	&& git config --global url."https://".insteadOf git://\
	# Cache for 1 hour
	#&&git config --global credential.helper "cache --timeout=3600"
	# Cache for 1 day
	#&&git config --global credential.helper "cache --timeout=86400"
	# Cache for 1 week
	&& git config --global credential.helper "cache --timeout=604800"
	# store credential to a file
	#&&git config --global credential.helper 'store --file ~/.git-credentials'


#RUN mkdir adv-release-bsp
#RUN mkdir test

# Sync Yocto BSP
#RUN mkdir adv-release-bsp
#WORKDIR adv-release-bsp
#RUN repo init -u git://github.com/ADVANTECH-Corp/adv-arm-yocto-bsp.git -b imx-linux-zeus -m imx8LBVA1036.xml && repo sync

# Modift tunycompress source
#RUN sed -i 's#git.alsa-project.org#github.com/alsa-project#g' sources/meta-imx/meta-sdk/recipes-multimedia/tinycompress/tinycompress_1.1.6.bb

# Cerate a new build environment
#SHELL ["/bin/bash", "-c"]
#RUN MACHINE=imx8mprsb3720a1 DISTRO=fsl-imx-xwayland EULA=1 source imx-setup-release.sh -b build_rsb3720 && bitbake imx-image-full
#RUN MACHINE=imx8mprsb3720a1 DISTRO=fsl-imx-xwayland EULA=1 source imx-setup-release.sh -b build_rsb3720\
	#&&echo 'INHERIT += "rm_work"' >> conf/local.conf\
	#&&bitbake gstreamer1.0 && bitbake imx-image-full

#CMD ["-v", "/dev:/dev", "-v", "/lib/modules:/lib/modules", "-v","/usr/src:/usr/src", "/bin/bash"]

