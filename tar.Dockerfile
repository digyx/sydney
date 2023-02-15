FROM elixir:alpine AS build_stage

# Config
ENV MIX_ENV prod
WORKDIR /opt/build

# Dependendies
COPY mix.* ./

RUN mix local.hex --force && \
  mix local.rebar --force && \
  mix deps.get --only prod && \
  mix deps.compile

# Build project
COPY lib ./lib
RUN mix release sydney

FROM alpine:3.16

RUN apk add \
    --update \
    --no-cache \
    openssl ncurses libstdc++

WORKDIR /opt/sydney
COPY entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh
COPY --from=build_stage /opt/build/_build/prod/sydney-0.1.0.tar.gz sydney-0.1.0.tar.gz

CMD ["/opt/sydney/entrypoint.sh"]
