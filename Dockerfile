# Install MaixPy develop enviroment.(maixpy)
#
# VERSION 0.3.0
FROM ubuntu:18.04
MAINTAINER Hiroshi TAKEMOTO <take.pwave@gmail.com>

RUN apt-get update
RUN apt-get install -y build-essential cmake wget sudo git
RUN apt-get install -y python3.7 python3.7-distutils
RUN ln -s /usr/bin/python3.7 /usr/bin/python
RUN cd /tmp  \
	&& wget --quiet  https://bootstrap.pypa.io/get-pip.py  \
	&& python get-pip.py

# install tensorflow and toco
RUN pip3 install tensorflow toco pyserial==3.4

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
	&& pip3 install --user -r requirements.txt \
	&& cd projects/maixpy_k210 \
	&& python project.py build

# install Maix_Toolbox
RUN cd $HOME \
	&& git clone https://github.com/sipeed/Maix_Toolbox.git
COPY get_nncase-mod.sh /tmp/get_nncase-mod.sh
RUN cd $HOME/Maix_Toolbox \
	&& /bin/sh /tmp/get_nncase-mod.sh

CMD ["/bin/bash"]