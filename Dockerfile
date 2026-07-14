# Usa la imagen oficial, Docker la bajará automáticamente para tu arquitectura M4
FROM rust:1.80-slim-bookworm AS builder

# Instalar las dependencias de Kafka (librdkafka) y compilación
RUN apt-get update && apt-get install -y pkg-config libssl-dev build-essential libsasl2-dev

WORKDIR /app
COPY . .
RUN cargo build --release

# Imagen final ligera (también nativa ARM64)
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y libssl-dev ca-certificates libsasl2-2

WORKDIR /app
RUN mkdir -p /app/uploads && chmod -R 777 /app/uploads

COPY --from=builder /app/target/release/nombre_de_tu_binario /app/worker

CMD ["/app/worker"]