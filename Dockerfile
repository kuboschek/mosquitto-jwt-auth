FROM alpine AS build

RUN apk --no-cache add rust cargo git
ADD . /mosquitto-jwt-auth
RUN cd /mosquitto-jwt-auth && cargo build --release

FROM eclipse-mosquitto
LABEL maintainer="Leonhard Kuboschek <leo@jacobs-alumni.de>" \
      description="Eclipse Mosquitto MQTT Broker with JWT authentication"

RUN apk --no-cache add libgcc
COPY --from=build /mosquitto-jwt-auth/target/release/libmosquitto_jwt_auth.so /mosquitto/plugins/libmosquitto_jwt_auth.so
ADD mosquitto_docker.conf /mosquitto/config/mosquitto.conf