FROM node:16.9.1
# Update the image to the latest packages & get some network test tools
# Install VIM - change this to an editor of your choice - sorry I was raised by savages
RUN apt-get update && \
    apt-get -y install git iputils-ping iproute2 vim && \
    mkdir -p /user/app

# Need to specify an existing directory so that all our other commands have a consistent working directory to run in
WORKDIR /usr/app

# Steps taken from install SDK guide
# Follow the steps to get started with our SDK:
# https://docs.couchbase.com/nodejs-sdk/current/hello-world/start-using-sdk.html
RUN npm init -y && npm install couchbase --save

# Hack to just sleep so we can attach
CMD ["sleep","3600"]