# Dockerfile
# how to use the Dockerfile, It will upgrade git version to v2.32.0 and python version to v3.6 and repo to v2.45.
$ mkdir test && cd test
$ git clone https://github.com/JemsCheng-Advantech/Dockerfile.git -b ${branch}
$ cd Dockerfile
# Build image
# Yocto40
$ docker build -t advrisc/u20.04-imx8lbv1-build .
# Yocto30
$ docker build -t advrisc/u18.04-imx8lbv1-build .

# And the image should be built successfully. Check the image by
$ docker images

# remove the image your build
# Yocto40
$ docker rmi advrisc/u20.04-imx8lbv1-build
# Yocto30
$ docker rmi advrisc/u18.04-imx8lbv1-build

# Docker run the image
# Yocto40
$ docker run --privileged -it --name ${CONTAINER_NAME} -v ${WORKSPACE}:/home/adv/adv-release-bsp -v /dev:/dev advrisc/u20.04-imx8lbv1-build /bin/bash
# Yocto30
$ docker run --privileged -it --name ${CONTAINER_NAME} -v ${WORKSPACE}:/home/adv/adv-release-bsp -v /dev:/dev -v /lib/modules:/lib/modules -v /usr/src:/usr/src advrisc/u18.04-imx8lbv1-build /bin/bash


