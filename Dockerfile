# 使用您提供的基礎映像檔
#FROM advrisc/u18.04-imx8lbv1
FROM advrisc/u20.04-imx8lbv1

# Set default shell to bash
SHELL ["/bin/bash", "-c"]

# 設置環境變數
ENV USER_NAME=adv
ENV USER_ID=adv

ENV MANIFEST_URL=git://github.com/ADVANTECH-Corp/adv-arm-yocto-bsp.git
ENV MANIFEST_BRANCH=imx-linux-scarthgap
#ENV MANIFEST_TAG=${SOC}LBV${TAG}.xml

ENV SOC=imx8
ENV MC=imx8mprsb3720a2
ENV HW=rsb3720
ENV TAG=F0138
ENV BDIR=build_${HW}_${TAG}

ENV MANIFEST_TAG=${SOC}LBV${TAG}.xml
ENV IMAGE=imx-image-full

# 安裝編譯套件
RUN sudo apt install gawk wget git diffstat unzip texinfo gcc build-essential\
	chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils\
	iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev\
	python3-subunit mesa-common-dev zstd liblz4-tool file locales -y


# 設定工作目錄
WORKDIR /home/${USER_NAME}/adv-release-bsp

# 賦予權限
RUN chown -R ${USER_ID}:${USER_ID} /home/${USER_NAME}/adv-release-bsp

# 切換到非 root 使用者
USER ${USER_NAME}

# 定義容器啟動時的預設行為 (例如，保持開啟讓使用者可以進入)
#CMD ["/bin/bash"]

RUN git config --global user.name "Your Name"
RUN git config --global user.email you@example.com

RUN export GIT_SSL_NO_VERIFY=1\
	&& git config --global http.sslverify false\
	&& git config --global url."https://".insteadOf git://\
	# Cache for 1 hour
	#&& git config --global credential.helper "cache --timeout=3600"
	# Cache for 1 day
	#&& git config --global credential.helper "cache --timeout=86400"
	# Cache for 1 week
	&& git config --global credential.helper "cache --timeout=604800"
	# store credential to a file
	#&& git config --global credential.helper 'store --file ~/.git-credentials'


#CMD ["-v", "/dev:/dev", "-v", "/lib/modules:/lib/modules", "-v","/usr/src:/usr/src", "/bin/bash"]

# Download Yocto Source
RUN repo init -u ${MANIFEST_URL} -b ${MANIFEST_BRANCH} -m ${MANIFEST_TAG}
RUN repo sync

# Setup Build Environment
RUN EULA=1 MACHINE=${MC} DISTRO=fsl-imx-xwayland source imx-setup-release.sh -b ${BDIR} && \
	bitbake ${IMAGE} --runall=fetch && \
	echo 'INHERIT += "rm_work"' >> conf/local.conf && \
	echo 'INHERIT += "BB_NUMBER_THREADS = " 6 "' >> conf/local.conf && \
	echo 'INHERIT += "PARALLEL_MAKE = " -j6 "' >> conf/local.conf && \
	echo 'SSTATE_DIR = "${BSPDIR}//sstate-cache"' >> conf/local.conf


#WORKDIR ${BDIR}
#RUN bitbake ${IMAGE} --runall=fetch
#RUN /bin/bash -c source setup-environment ${BDIR} && bitbake ${IMAGE} --runall=fetch

CMD ["-v", "/dev:/dev", "-v", "/lib/modules:/lib/modules", "-v","/usr/src:/usr/src", "/bin/bash"]
