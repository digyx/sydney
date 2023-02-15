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

WORKDIR /opt/sydney
RUN apk add \
    --update \
    --no-cache \
    openssl ncurses libstdc++
COPY --from=build_stage /opt/build/_build/prod/rel/sydney /opt/sydney

ENTRYPOINT ["/opt/sydney/bin/sydney"]
CMD ["start"]
