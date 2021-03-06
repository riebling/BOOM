FROM python:2.7-alpine
MAINTAINER Boyue Li <boyuel@andrew.cmu.edu>

# Update Apk
RUN apk --no-cache update

# Install xz, curl and make
RUN apk --no-cache add xz curl make

# Install Git, GraphViz
RUN apk --no-cache add git graphviz

# Install RabbitMQ, from https://github.com/pikado/alpine-rabbitmq/blob/master/Dockerfile
ENV RABBITMQ_VERSION 3.6.14
ENV RABBITMQ_HOME /usr/local/rabbitmq-server
RUN apk --no-cache add erlang erlang-mnesia erlang-public-key erlang-crypto erlang-ssl erlang-sasl \
    erlang-asn1 erlang-inets erlang-os-mon erlang-xmerl erlang-eldap erlang-syntax-tools
RUN curl -sL https://www.rabbitmq.com/releases/rabbitmq-server/v${RABBITMQ_VERSION}/rabbitmq-server-generic-unix-${RABBITMQ_VERSION}.tar.xz | tar -xJ -C /usr/local
RUN ln -s /usr/local/rabbitmq*${RABBITMQ_VERSION} ${RABBITMQ_HOME}
ENV PATH="${PATH}:/usr/local/rabbitmq-server/sbin"

# Install MongoDB
RUN apk --no-cache add mongodb

# Install Python dependencies
RUN apk --no-cache add gcc gfortran musl-dev openblas-dev
RUN pip --no-cache-dir install numpy glog nltk pika pydotplus pymongo pytest pyyaml six
RUN pip --no-cache-dir install rouge

# If NLTK data is needed
#RUN python -m nltk.downloader all

# Install BOOM
# Clone code from GitHub
RUN git clone https://github.com/liboyue/BOOM.git boom
# Or copy from your local dir
# COPY . /boom
#RUN ls /boom
RUN cd /boom && make install

# Create data dir for MongoDB
RUN mkdir /data
WORKDIR /

# RabbitMQ port
EXPOSE 5672
EXPOSE 15672

# MongoDB port
EXPOSE 27017
