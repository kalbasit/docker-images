FROM node:6

# Set the versions
ENV XO_SERVER_REF v5.8.0
ENV XO_WEB_REF v5.8.0

# see https://xen-orchestra.com/docs/from_the_sources.html

# tell apt-get to use a noninteractive frontend
ENV DEBIAN_FRONTEND noninteractive

# apt-utils is needed to fix the problem `debconf: delaying package
# configuration, since apt-utils is not installed`
RUN apt-get update \
  && apt-get install -y --no-install-recommends apt-utils

# Update the system to benefit from any security update
RUN apt-get dist-upgrade -y

# install dependencies needed by the build
RUN apt-get install -y --no-install-recommends build-essential libpng-dev python-minimal

# Set the workdir
WORKDIR /usr/src/xo/server

# Clone the project
RUN git clone -b "$XO_SERVER_REF" --depth 1 https://github.com/vatesfr/xo-server.git .
RUN git clone -b "$XO_WEB_REF" --depth 1 https://github.com/vatesfr/xo-web.git ../web

# node-gyp is required but not installed upstream
# TODO: report it upstream
RUN npm install -g node-gyp

# install the server
RUN set -x \
	&& yarn

# install the web client
RUN set -x \
	&& cd ../web \
	&& yarn

# create the config file
RUN sed " \
		s!#'/': '/path/to/xo-web/dist/'!'/': '../web/dist/'!; \
		s!#uri: ''!uri: 'redis://redis:6379'!; \
	" sample.config.yaml > .xo-server.yaml

# clean up
RUN apt-get remove -y apt-utils build-essential libpng-dev \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# start the server
EXPOSE 80
CMD ["yarn", "start"]
