FROM debian:stretch-slim

RUN apt-get update && apt-get install -y \
  make \
  python \
  python-serial \
  wget \
  tar \
  libncurses5-dev \
&& rm -rf /var/lib/apt/lists/*

WORKDIR /opt

#RUN pip --no-cache-dir install pyserial

#RUN wget "https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2018q4/gcc-arm-none-eabi-8-2018-q4-major-linux.tar.bz2?revision=d830f9dd-cd4f-406d-8672-cca9210dd220?product=GNU%20Arm%20Embedded%20Toolchain,64-bit,,Linux,8-2018-q4-major" -O temp.tar.bz2 \
RUN wget "https://developer.arm.com/-/media/Files/downloads/gnu-rm/7-2018q2/gcc-arm-none-eabi-7-2018-q2-update-linux.tar.bz2?revision=bc2c96c0-14b5-4bb4-9f18-bceb4050fee7?product=GNU%20Arm%20Embedded%20Toolchain,64-bit,,Linux,7-2018-q2-update" -O temp.tar.bz2 \
#RUN wget "https://developer.arm.com/-/media/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2?revision=375265d4-e9b5-41c8-bf23-56cbe927e156?product=GNU%20Arm%20Embedded%20Toolchain,64-bit,,Linux,7-2017-q4-major" -O temp.tar.bz2 \
&& tar -xvjf temp.tar.bz2 \
&& rm -rf temp.tar.bz2

RUN mkdir /opt/stm32loader/ && \
    cd /opt/stm32loader/ && \
    wget https://raw.githubusercontent.com/jsnyder/stm32loader/master/stm32loader.py && \
    chmod +x /opt/stm32loader/stm32loader.py && \
    ln -s /opt/stm32loader/stm32loader.py /usr/local/bin/stm32loader

#ENV PATH="/opt/gcc-arm-none-eabi-8-2018-q4-major/bin:${PATH}"
ENV PATH="/opt/gcc-arm-none-eabi-7-2018-q2-update/bin:${PATH}"
#ENV PATH="/opt/gcc-arm-none-eabi-7-2017-q4-major/bin:${PATH}"

RUN mkdir /home/src

WORKDIR /home/src

ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID -o mightyteam
RUN useradd -m -u $UID -g $GID -o -s /bin/bash mightyteam

RUN usermod -a -G dialout mightyteam
RUN usermod -a -G plugdev mightyteam

USER mightyteam


#ENTRYPOINT ["make", "-C"]

#CMD ["./", "all"]
