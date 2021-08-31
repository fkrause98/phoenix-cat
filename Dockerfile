FROM bitwalker/alpine-elixir-phoenix:latest AS build
# install build dependencies
RUN apk add --no-cache postgresql-client bash openssl libgcc libstdc++ ncurses-libs git npm
RUN apk upgrade --no-cache


# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod
ENV DATABASE_URL=ecto://postgres:postgres@localhost:5432/chat_dev
ENV SECRET_KEY_BASE=p34bHfW2Og27xrqhYOzicPj/LWp59pWbeEnnMb5TTRgwnYaNuHd8qm/nRq3yFcVs

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# build assets
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

# compile and build release
COPY lib lib
# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release

# prepare release image
FROM bitwalker/alpine-elixir-phoenix:latest AS app

RUN apk add --no-cache openssl ncurses-libs libstdc++

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/chat ./

ENV HOME=/app

CMD ["bin/chat", "start"]
