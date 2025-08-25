# Alpine Latest 25/08/25
FROM alpine:3.22.1

# Build Args
# TZ
ARG TIMEZONE='America/El_Salvador'
# ZULU VERSION
ARG ZULU_VERSION="zulu21"
# JAVA VERSION
ARG JAVA_VERSION="21.0.8"
# Java Virtual Machine Type
# Possible values: jdk, jre, jdk-headless, jre-headless
ARG JVM_TYPE="jdk-headless"

# Zulu Repo Key
# hadolint ignore=DL3008
ARG ZULU_KEY_SHA256=6c6393d4755818a15cf055a5216cffa599f038cd508433faed2226925956509a

# ZULU_KEY_URL is a public URL, safe to use as ARG.
# hadolint ignore=DL3008
ARG ZULU_KEY_URL="https://cdn.azul.com/public_keys/alpine-signing@azul.com-5d5dc44c.rsa.pub"

# UTF-8 
#
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8' TZ=${TIMEZONE}

# AVOID wget SSL error
#
RUN apk add --no-cache ca-certificates wget tzdata && update-ca-certificates

# Dowload ZULU PubKey
#
RUN wget --quiet ${ZULU_KEY_URL} -P /etc/apk/keys/ 

# Validates CHECKSUM
#
RUN echo "${ZULU_KEY_SHA256} /etc/apk/keys/alpine-signing@azul.com-5d5dc44c.rsa.pub" | sha256sum -c - 

# Add repository
#
RUN echo "https://repos.azul.com/zulu/alpine" | tee -a /etc/apk/repositories

# Update and Upgrade
#
RUN apk update && apk upgrade

# Install ZULU JDK
RUN apk --no-cache add ${ZULU_VERSION}-${JVM_TYPE}~=${JAVA_VERSION}

# SET JAVA_HOME
#
ENV JAVA_HOME=/usr/lib/jvm/${ZULU_VERSION} \
    PATH=/usr/lib/jvm/${ZULU_VERSION}/bin:$PATH \
    JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8"
