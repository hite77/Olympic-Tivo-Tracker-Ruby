#FROM phusion/baseimage:0.9.18
#FROM ruby:2.1-onbuild
FROM alpine:3.3

ENV BUILD_PACKAGES curl-dev ruby-dev build-base

# Update and install base packages
RUN apk update && apk upgrade && apk add bash $BUILD_PACKAGES

# Install ruby and ruby-bundler
RUN apk add ruby ruby-io-console ruby-bundler

# Clean APK cache
RUN rm -rf /var/cache/apk/*

#install rvm
#RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
#RUN curl -L https://get.rvm.io | bash -s stable --ruby

#install ruby 2.2.1
#RUN ruby -v

EXPOSE 443

#COPY run /etc/service/webrick/run
RUN mkdir -p /usr/local/bin/
COPY webrick_server.rb /usr/local/bin/webrick_server.rb

#RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
CMD ["ruby", "/usr/local/bin/webrick_server.rb"]
COPY Dockerfile README.md /opt/
