FROM alpine:latest

WORKDIR "/webhook"

COPY requirements.txt .
COPY *.py ./

RUN apk update && \
 apk add --no-cache font-noto-emoji font-noto-cjk-extra python3 python3-dev py3-numpy py3-matplotlib py3-scipy py3-requests ffmpeg gcompat && \
 apk add --no-cache --virtual .build-deps git make gcc g++ wget unzip && \
 wget https://bootstrap.pypa.io/get-pip.py && \
 python3 ./get-pip.py && \
 cd / && \
 git clone https://github.com/hihkm/DanmakuFactory.git && \
 cd DanmakuFactory && \
 mkdir temp && \
 make && \
 cd /webhook && \
 pip3 install --upgrade -r requirements.txt && \
 wget https://raw.githubusercontent.com/valkjsaaa/Bilibili-Toolkit/7b86a61214149cc3f790d02d5d06ecd7540b9bdb/bilibili.py && \
 apk del .build-deps && \
 mkdir /BililiveRecorder && \
 cd /BililiveRecorder && \
 wget https://github.com/BililiveRecorder/BililiveRecorder/releases/latest/download/BililiveRecorder-CLI-linux-x64.zip && \
 unzip BililiveRecorder-CLI-linux-x64.zip && \
 chmod a+x ./BililiveRecorder.Cli && \
 rm -f ./BililiveRecorder-CLI-linux-x64.zip

WORKDIR "/storage"
ENV PYTHONUNBUFFERED=1
CMD python3 -u /webhook/process_video.py