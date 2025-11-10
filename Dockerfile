# Alpine Latest 25/08/25
FROM alpine:3.22.2 AS builder

# JAVA VERSION
ARG JAVA_VERSION="21.0.8"
# ZULU VERSION
ARG ZULU_VERSION=zulu${JAVA_VERSION%%.*}
# Java Virtual Machine Type
# Possible values: jdk, jdk-headless
ARG JVM_TYPE="jdk-headless"
# Zulu Public Key Sha256sum
# You can get the latest sha256 from https://www.azul.com/downloads/?package
ARG ZULU_SHA256=6c6393d4755818a15cf055a5216cffa599f038cd508433faed2226925956509a

# ZULU_PUBKEY_URL is a public URL, safe to use as ARG.
ARG ZULU_PUBKEY_URL="https://cdn.azul.com/public_keys/alpine-signing@azul.com-5d5dc44c.rsa.pub"

SHELL ["/bin/ash", "-o", "pipefail", "-c"]

# PubKey Sha256sum
# hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates wget binutils\
 && update-ca-certificates \
 && wget --quiet "${ZULU_PUBKEY_URL}" -P /etc/apk/keys/ \
 && echo "${ZULU_SHA256}  /etc/apk/keys/alpine-signing@azul.com-5d5dc44c.rsa.pub" | sha256sum -c - \
 && echo "https://repos.azul.com/zulu/alpine" >> /etc/apk/repositories

# Install ZULU JDK
# hadolint ignore=DL3018
RUN set -eux; \
    if echo "$JAVA_VERSION" | grep -Eq '^[0-9]+$'; then \
      printf "\nWARNING: JAVA_VERSION=%s no es específico.\n" "$JAVA_VERSION"; \
      printf "Instalando la última versión estable disponible para %s...\n\n" "$ZULU_VERSION"; \
      # apk add > /dev/null elimina su salida estándar
      apk add --no-cache "${ZULU_VERSION}-${JVM_TYPE}"; \
    else \
      printf "\nInstalando versión exacta: %s-%s~=%s\n\n" "$ZULU_VERSION" "$JVM_TYPE" "$JAVA_VERSION"; \
      apk add --no-cache "${ZULU_VERSION}-${JVM_TYPE}~=${JAVA_VERSION}"; \
    fi

# JLINK optimization for JDK or JDK-HEADLESS
#
RUN echo "Ejecutando jlink para generar runtime optimizado..."; \
    /usr/lib/jvm/${ZULU_VERSION}/bin/jlink \
    --module-path /usr/lib/jvm/${ZULU_VERSION}/jmods \
    --add-modules java.base,java.sql,java.naming,java.xml,java.instrument,jdk.unsupported,java.desktop,jdk.management,java.management,java.net.http,java.logging \
    --strip-debug \
    --no-header-files \
    --no-man-pages \
    --compress 1 \
    --output /opt/java-runtime; 

FROM alpine:3.22.2

# Build Args
# TZ
ARG TIMEZONE='America/El_Salvador'

# Create a non-root user to run the application
#
RUN addgroup -S spring && adduser -S spring -G spring

# Install CA Certificates
#
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Copy Java Runtime
#
COPY --from=builder /opt/java-runtime /usr/lib/jvm/current

# Set Timezone
# hadolint ignore=DL3018
RUN apk add --no-cache tzdata \ 
    && mkdir -p /app \
    && chown -R spring:spring /app

# SET JAVA_HOME
#
ENV LANG=C.utf8 \
    JAVA_HOME=/usr/lib/jvm/current \
    PATH=/usr/lib/jvm/current/bin:$PATH \
    TZ=${TIMEZONE} \
    JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8"

# NON-ROOT USER
#
USER spring:spring

# DEFAULT DIRECTORY 
#
WORKDIR /app
