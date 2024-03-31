################################################################################
# builder
################################################################################
FROM node:18.19.0 as builder

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    ts-node \
    tzdata

WORKDIR /npm/
COPY ./package.json /npm/package.json
RUN npm config set prefix "/npm/"
RUN npm install --prefix "/npm/"

################################################################################
# development
################################################################################
FROM node:18.19.0 as dev

COPY --from=builder /usr/bin /usr/bin
COPY --from=builder /usr/lib /usr/lib
COPY --from=builder /usr/share /usr/share
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/lib /usr/local/lib
COPY --from=builder /npm/node_modules /npm/node_modules

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    ca-certificates \
    git \
    openjdk-17-jdk

RUN npm config set prefix "/npm/"

RUN git config --global --add safe.directory /workspace

################################################################################
# testing
################################################################################
FROM node:18.19.0 as test

ENV TZ Asia/Tokyo

COPY --from=builder /usr/bin /usr/bin
COPY --from=builder /usr/lib /usr/lib
COPY --from=builder /usr/share /usr/share
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/lib /usr/local/lib
COPY --from=builder /npm/node_modules /npm/node_modules

RUN npm install --save-dev jest ts-jest @types/jest typescript
RUN npm config set prefix "/npm/"

COPY ./app/src /app/src
COPY ./app/assets /app/assets
COPY ./app/test /app/test
CMD ["npm", "test"]

################################################################################
# production
################################################################################
FROM node:18.19.0 as prod

ENV TZ Asia/Tokyo

COPY --from=builder /usr/bin /usr/bin
COPY --from=builder /usr/lib /usr/lib
COPY --from=builder /usr/share /usr/share
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/lib /usr/local/lib
COPY --from=builder /npm/node_modules /npm/node_modules

RUN npm config set prefix "/npm/"

COPY ./app/src /app/src
COPY ./app/assets /app/assets
CMD ["ts-node", "/app/index.ts"]
