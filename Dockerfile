FROM elixir:1.16.3-alpine

RUN apk add --update git

# prepare build dir
RUN mkdir /app
WORKDIR /app

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY . .
RUN mix local.hex --force && \
      mix deps.get && \
      mix escript.build

ENTRYPOINT ["./assets_flow"]
