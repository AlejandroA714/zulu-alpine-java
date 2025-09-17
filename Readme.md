# 🐳 Zulu Java on Alpine (JDK | Headless/Full)

Imagen Docker basada en **Alpine 3.22.1** con **Azul Zulu** Java.  
Permite elegir la **versión de Java**, la **distribución Zulu** y el **tipo de JVM** (`jdk`, `jdk-headless`) en tiempo de build.

👉 Incluye optimización con **`jlink`**, soporte de **zona horaria (`tzdata`)**, certificados SSL y configuración UTF-8 global.  

La imagen pesa menos de 200mb

[Docker Hub Repo](https://hub.docker.com/repository/docker/alejandroa714/zulu-jvm/general)

---

## 🚀 Características

- Base **Alpine 3.22.1** (ligera y moderna).  
- Repositorio oficial **Azul Zulu** para Alpine.  
- **Verificación SHA256** de la clave pública de Azul.  
- Certificados SSL (`ca-certificates`) incluidos en runtime.  
- Soporte de **`tzdata`** y variable `TZ` para zona horaria.  
- **UTF-8 global** mediante `LANG` y `JAVA_TOOL_OPTIONS`.  
- `jlink` genera un runtime reducido (~110 MB).  
- Variables de entorno listas para ejecutar (`JAVA_HOME`, `PATH`).  

---

## ⚙️ Build Args (parámetros)

| Arg             | Valor por defecto       | Descripción |
|-----------------|-------------------------|-------------|
| `JAVA_VERSION`  | `21.0.8`               | Versión específica del JDK/JRE (`major.minor.patch`). |
| `ZULU_VERSION`  | `zulu${JAVA_VERSION%%.*}` | Línea de Zulu (`zulu17`, `zulu21`, etc.). |
| `JVM_TYPE`      | `jdk-headless`          | Tipo de JVM: <br>- `jdk` <br>- `jdk-headless` |
| `TIMEZONE`      | `America/El_Salvador`   | Zona horaria del contenedor. |
| `ZULU_PUBKEY_URL` | URL pública de la clave GPG de Azul. |
| `ZULU_SHA256`   | Hash SHA256 de la clave pública (para verificación). |

> **Nota:** `ZULU_PUBKEY_URL` y `ZULU_SHA256` son **públicos**, no representan información sensible.

---

## 📦 Versiones soportadas

La imagen puede generar builds para estas líneas de Zulu (OpenJDK):  

| Línea Zulu | Estado | Comentarios |
|------------|--------|-------------|
| `zulu17`   | LTS    | Soporte a largo plazo (estable). |
| `zulu21`   | LTS    | Última versión LTS (recomendado). |
| `zulu15`   | EOL    | Fin de soporte, solo para legacy. |
| `zulu20`   | STS    | Soporte corto, para pruebas. |

Consulta las versiones exactas aquí:  
👉 [Descargas Azul Zulu](https://www.azul.com/downloads/?os=alpine-linux&package=jdk#zulu)

---

## 🔨 Cómo construir (build)

### Java 21 (JDK Headless, por defecto)
```bash
docker build \
  --tag zulu-alpine:21-jdk-headless \
  .
