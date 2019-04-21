# Install MaixPy develop enviroment.(maixpy)
#
# VERSION 0.3.0
FROM ubuntu:16.04
MAINTAINER Hiroshi TAKEMOTO <take.pwave@gmail.com>

RUN apt-get update
RUN apt-get install -y build-essential cmake wget sudo git
RUN apt-get install -y python3
RUN ln -s /usr/bin/python3 /usr/bin/python

# install tool-chain
RUN cd /tmp \
	&& wget --quiet https://s3.cn-north-1.amazonaws.com.cn/dl.kendryte.com/documents/kendryte-toolchain-ubuntu-amd64-8.2.0-20190213.tar.gz \
	&& cd /opt \
	&& tar xfo /tmp/kendryte-toolchain-ubuntu-amd64-8.2.0-20190213.tar.gz \
	&& chmod 755 /opt/kendryte-toolchain \
	&& rm /tmp/kendryte-toolchain-ubuntu-amd64-8.2.0-20190213.tar.gz

# create maix user
RUN useradd --comment "Maix User" --user-group --groups users --create-home maix
RUN echo 'maix ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/maix

USER maix
RUN cd $HOME && mkdir workspace

# install MaixPy
RUN cd $HOME \
	&& git clone --recursive https://github.com/sipeed/MaixPy.git \
	&& cd MaixPy \
	&& make -C mpy-cross \
	&& echo "toolchain_path=/opt/kendryte-toolchain" > ports/k210-freertos/config.conf \
	&& cd ports/k210-freertos \
	&& chmod +x build.sh; ./build.sh

CMD ["/bin/bash"]
