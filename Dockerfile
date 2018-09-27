FROM ubuntu:bionic AS build

# Install tools required for the project
RUN apt-get update \
    && apt-get install gcc -y \
    && apt-get install g++ -y \
    && apt-get install cmake -y \
    && apt-get install wget -y 

# Install Boost
RUN cd /home \
    && wget http://downloads.sourceforge.net/project/boost/boost/1.68.0/boost_1_68_0.tar.gz \
    && tar xfz boost_1_68_0.tar.gz \
    && rm boost_1_68_0.tar.gz \
    && cd boost_1_68_0 \
    && ./bootstrap.sh --with-libraries=system \
    && ./b2 install

# Copy the entire project and build it
COPY . /cpp/src/project/ 
WORKDIR /cpp/src/project/

RUN cmake -Bbin -H. && cmake --build bin

FROM ubuntu:bionic 
COPY --from=build /cpp/src/project/bin/websocket-chat-server /app/
COPY --from=build /cpp/src/project/chat_client.html /app/wwwroot/index.html

ENTRYPOINT ["/app/websocket-chat-server", "0.0.0.0", "8080", "/app/wwwroot"]

EXPOSE 8080

