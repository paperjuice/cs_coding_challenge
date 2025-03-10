# This file is based on these images:
#
#   - https://hub.docker.com/r/hexpm/elixir/tags - for the build image
#   - https://hub.docker.com/_/debian?tab=tags&page=1&name=bullseye-20221004-slim - for the release image
#   - https://pkgs.org/ - resource for finding needed packages
#
ARG ELIXIR_VERSION=1.16.1
ARG OTP_VERSION=26.2.2
ARG DEBIAN_VERSION=bullseye-20240130-slim

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"

FROM ${BUILDER_IMAGE} AS builder

# install build dependencies
RUN apt-get update -y && \
    apt-get install -y build-essential git && \
    apt-get install wget -y && \
    apt-get install curl -y && \
    apt install vim -y && \
    apt-get clean && \
    apt-get upgrade -y && \
    apt install inetutils-ping  -y && \
    apt install inotify-tools -y && \
    rm -f /var/lib/apt/lists/*_*

# prepare build dir
WORKDIR /app

RUN apt-get update -y && \
    apt-get install -y libstdc++6 openssl libncurses5 locales && \
    apt-get clean && \
    rm -f /var/lib/apt/lists/*_*

# install hex + rebar
RUN mix local.hex --force && \
    mix archive.install --force hex phx_new 1.7.20 && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV="dev"

COPY . .

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# set runner ENV
ENV MIX_ENV="dev"

EXPOSE 9963

CMD ["deploy/app_entrypoint.sh"]

