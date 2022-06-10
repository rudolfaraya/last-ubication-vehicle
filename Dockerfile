#FROM ruby:2.5.3-alpine
#
#ENV BUNDLER_VERSION=2.3.5
#
#RUN apk add --update --no-cache \
#      binutils-gold \
#      build-base \
#      curl \
#      file \
#      g++ \
#      gcc \
#      git \
#      less \
#      libstdc++ \
#      libffi-dev \
#      libc-dev \
#      linux-headers \
#      libxml2-dev \
#      libxslt-dev \
#      libgcrypt-dev \
#      make \
#      netcat-openbsd \
#      nodejs \
#      openssl \
#      pkgconfig \
#      postgresql-dev \
#      python \
#      tzdata \
#      yarn
FROM rudolfaraya/rails-base-ruby253
RUN gem update --system 3.2.3
RUN gem install bundler -v 2.3.5
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle check || bundle install
COPY package.json yarn.lock ./
RUN yarn install --check-files --ignore-engines
COPY . ./
SHELL ["/bin/bash", "-c"]