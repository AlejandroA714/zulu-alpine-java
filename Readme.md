# Zulu Java on Alpine (JDK/JRE | Headless/Full)

Imagen Docker basada en **Alpine 3.22.1** con **Azul Zulu** Java. Permite elegir la **versión de Java**, la **distribución Zulu** y el **tipo de JVM** (`jdk`, `jre`, `jdk-headless`, `jre-headless`) en tiempo de build.

> Ideal para compilación (JDK) y/o ejecución (JRE o Headless), con verificación de integridad de la clave del repo de Azul.

---

## Características

- Base **Alpine 3.22.1** (ligera y moderna).  
- Repositorio oficial **Azul Zulu** para Alpine.  
- **Verificación SHA256** de la clave pública de Azul.  
- Soporte de `tzdata` y variable `TZ` para zona horaria.  
- JVM configurada en UTF-8 mediante `JAVA_TOOL_OPTIONS`.  
- Variables de entorno listas para compilar y ejecutar (`JAVA_HOME`, `PATH`).  
- Selección flexible del **tipo de JVM** 

---

## Build Args (parámetros)

| Arg               | Valor por defecto                              | Descripción |
|-------------------|-----------------------------------------------|-------------|
| `TIMEZONE`        | `America/El_Salvador`                         | Zona horaria del contenedor. |
| `ZULU_VERSION`    | `AUTOCALCULADO`                               | Línea de Zulu: soporta `zulu15`, `zulu17`, `zulu20`, `zulu21`, etc. |
| `JAVA_VERSION`    | `21.0.8`                                      | Versión específica del JDK/JRE (`major.minor.patch`). |
| `JVM_TYPE`        | `jre-headless`                                | Tipo de JVM a instalar:<br>- `jdk`: Kit completo con librerías gráficas.<br>- `jdk-headless`: JDK sin librerías gráficas (más liviano, ideal para servidores y compilación sin GUI).<br>- `jre`: Solo entorno de ejecución con librerías gráficas.<br>- `jre-headless`: Solo runtime minimalista. |
| `ZULU_KEY_URL`    | `https://cdn.azul.com/public_keys/alpine-signing@azul.com-5d5dc44c.rsa.pub` | URL pública de la clave GPG de Azul. |
| `ZULU_KEY_SHA256` | `6c6393d4755818a15cf055a5216cffa599f038cd508433faed2226925956509a` | Hash SHA256 de la clave pública (para verificación de integridad). |

> **Nota:** `ZULU_KEY_URL` y `ZULU_KEY_SHA256` son **públicos** y no representan información sensible.

---

## Versiones de Zulu soportadas

La imagen puede generar builds para estas líneas de Zulu (OpenJDK):  

| Línea Zulu | Estado | Comentarios |
|------------|--------|-------------|
| `zulu15`   | EOL (fin de soporte) | Solo para compatibilidad con proyectos legacy. |
| `zulu17`   | LTS | Soporte a largo plazo, recomendado para producción estable. |
| `zulu20`   | Soporte a corto plazo | Experimental o para testing. |
| `zulu21`   | LTS | Última versión LTS (ideal para producción moderna). |

Consulta las versiones exactas disponibles aquí:  
[https://www.azul.com/downloads/](https://www.azul.com/downloads/?os=alpine-linux&package=jdk#zulu)

---

## Cómo construir (build)

### Java 21 LTS (JDK Headless, por defecto)
docker build \
  --tag zulu-alpine:21-jdk-headless \
  .

### JAVA 17 JRE LTS
docker build \
  --build-arg JVM_TYPE=jre-headless \
  --tag zulu-alpine:21-jre \
  .

### JAVA 15 JRE
docker build \
  --build-arg ZULU_VERSION=zulu15 \
  --build-arg JAVA_VERSION=15.0.2 \
  --build-arg JVM_TYPE=jre-headless \
  --tag zulu-alpine:15-jre-headless \
  .
