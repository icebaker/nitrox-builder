FROM ruby:3.2.1-slim-bullseye AS builder-shared
RUN apt-get update && apt-get install -y --no-install-recommends git build-essential
RUN bundle config set --local without 'development:test'
ADD ./heavy.Gemfile /build/shared-heavy/Gemfile
WORKDIR /build/shared-heavy
RUN bundle install
# COPY ./lighstorm /build/lighstorm
COPY ./nitrox-core /build/app/nitrox-core
ADD ./lite.Gemfile /build/app/service/shared-lite/Gemfile
WORKDIR /build/app/service/shared-lite
RUN bundle install

FROM ruby:3.2.1-slim-bullseye AS builder-gems
RUN apt-get update && apt-get install -y --no-install-recommends git build-essential
RUN bundle config set --local without 'development:test'
COPY --from=builder-shared /usr/local/bundle /usr/local/bundle
WORKDIR /build
# COPY ./lighstorm /build/lighstorm
COPY ./nitrox-core /build/app/nitrox-core
ADD ./nitrox-{SERVICE}/Gemfile /build/app/service/nitrox-{SERVICE}-gems/Gemfile
WORKDIR /build/app/service/nitrox-{SERVICE}-gems
RUN bundle install

FROM ruby:3.2.1-slim-bullseye
RUN apt-get update && apt-get install -y --no-install-recommends git
# RUN git config --global --add safe.directory /nitrox/lighstorm
WORKDIR /nitrox
COPY --from=builder-gems /usr/local/bundle /usr/local/bundle
# COPY --from=builder-gems /build/lighstorm /nitrox/lighstorm
COPY --from=builder-gems /build/app/nitrox-core /nitrox/app/nitrox-core
COPY ./nitrox-{SERVICE} /nitrox/app/service/nitrox-{SERVICE}
RUN rm /nitrox/app/service/nitrox-{SERVICE}/Gemfile.lock
COPY --from=builder-gems /build/app/service/nitrox-{SERVICE}-gems/Gemfile.lock /nitrox/app/service/nitrox-{SERVICE}/Gemfile.lock
RUN rm -rf /nitrox/app/service/nitrox-{SERVICE}/.env && touch /nitrox/app/service/nitrox-{SERVICE}/.env
RUN mkdir /nitrox/app/service/nitrox-{SERVICE}/data
RUN chown 1000:1000 /nitrox/app/service/nitrox-{SERVICE}/data

# Debug Only:
RUN apt-get update && apt-get install -y --no-install-recommends \
      curl jq iputils-ping telnet openssl

USER 1000
RUN bundle config set --local without 'development:test'
WORKDIR /nitrox/app/service/nitrox-{SERVICE}
CMD ["bash", "./init.sh"]
