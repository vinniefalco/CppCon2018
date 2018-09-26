FROM ubuntu:bionic

RUN mkdir -p /home/cppcon/public_html

RUN apt-get update \
    && apt-get install gcc -y \
    && apt-get install g++ -y \
    && apt-get install cmake -y \
    && apt-get install wget -y


RUN cd /home \
    && wget http://downloads.sourceforge.net/project/boost/boost/1.68.0/boost_1_68_0.tar.gz \
    && tar xfz boost_1_68_0.tar.gz \
    && rm boost_1_68_0.tar.gz \
    && cd boost_1_68_0 \
    && ./bootstrap.sh --with-libraries=system \
    && ./b2 install \
    && cd /home \
    && rm -rf boost_1_68_0

RUN apt-get install -y wget zsh git
RUN wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | zsh || true

COPY .docker/console/.zshrc /root/.zshrc
COPY .docker/console/robbyrussell.zsh-theme /root/.oh-my-zsh/themes/robbyrussell.zsh-theme


COPY . /home/cppcon/public_html
WORKDIR /home/cppcon/public_html




