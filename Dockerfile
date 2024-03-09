# We're no longer using openjdk:17-slim as a base due to several unpatched vulnerabilities.
# The results from basing off of alpine are a smaller (by 47%) and faster (by 17%) image.
# Even with bash installed.     -Corbe
FROM alpine:latest

RUN addgroup -S mcserver -g 4000 && adduser -u 4000 mcserver -S mcserver -G mcserver

# Environment variables
ENV MC_VERSION="latest" \
    PAPER_BUILD="latest" \
    EULA="false" \
    MC_RAM="" \
    JAVA_OPTS=""

COPY papermc.sh .
RUN apk update \
    && apk add openjdk17-jre \
    && apk add bash \
    && apk add wget \
    && apk add jq \
    && mkdir /papermc \
    && mkdir /serverfiles

RUN chown -R 4000:4000 papermc
RUN chown 4000:4000 papermc.sh
USER mcserver

# Start script
CMD ["bash", "./papermc.sh"]

# Container setup
EXPOSE 25565/tcp
EXPOSE 25565/udp
# Dynmaps setup
EXPOSE 8123/tcp
EXPOSE 8123/udp

VOLUME /papermc
VOLUME /serverfiles
