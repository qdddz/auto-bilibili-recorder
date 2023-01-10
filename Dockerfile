ARG COMMON_IMAGE=ubuntu:focal
FROM ${COMMON_IMAGE}

ENV TZ=Asia/Shanghai
ARG DEBIAN_FRONTEND=noninteractive


RUN apt-get update && apt-get install -y wget git apt-transport-https fonts-noto-color-emoji fonts-noto-cjk-extra make gcc python3 python3-pip unzip && update-ca-certificates -f 

RUN cd /tmp && wget https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz && tar xf ffmpeg-release-amd64-static.tar.xz && mv ffmpeg-*-amd64-static/ffmpeg /usr/local/bin/ 

WORKDIR  "/BililiveRecorder"
RUN wget https://github.com/BililiveRecorder/BililiveRecorder/releases/latest/download/BililiveRecorder-CLI-linux-x64.zip 

RUN cd / && git clone https://github.com/hihkm/DanmakuFactory.git && cd DanmakuFactory && mkdir temp && make

WORKDIR "/webhook"

COPY requirements.txt .
COPY *.py .
RUN pip3 install --upgrade -r requirements.txt && pip3 install git+https://github.com/valkjsaaa/danmaku_tools.git@4853f226301f7f661bcdf6d2925148bc9ecdbffd && 
RUN wget https://raw.githubusercontent.com/valkjsaaa/Bilibili-Toolkit/7b86a61214149cc3f790d02d5d06ecd7540b9bdb/bilibili.py

WORKDIR "/storage"
ENV PYTHONUNBUFFERED=1
CMD python3 -u /webhook/process_video.py
