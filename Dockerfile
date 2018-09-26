FROM ubuntu:bionic

RUN apt-get update \
    && apt-get install gcc -y \
    && apt-get install g++ -y \
    && apt-get install cmake -y \
    && apt-get install wget -y \
    && apt-get install git -y

RUN cd /home \
    && wget http://downloads.sourceforge.net/project/boost/boost/1.68.0/boost_1_68_0.tar.gz \
    && tar xfz boost_1_68_0.tar.gz \
    && rm boost_1_68_0.tar.gz \
    && cd boost_1_68_0 \
    && ./bootstrap.sh --with-libraries=system \
    && ./b2 install \
    && cd /home \
    && rm -rf boost_1_68_0

COPY . /app 
WORKDIR /app

RUN cmake -Bbuild -H. && cmake --build build

CMD ./build/websocket-chat-server 0.0.0.0 8080 ./html

EXPOSE 8080

