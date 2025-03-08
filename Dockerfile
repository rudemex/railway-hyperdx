# Usa la imagen oficial de HyperDX Local como base
FROM hyperdx/hyperdx-local:latest

# Instalar Fluentd y dependencias adicionales en Alpine
RUN apk add --no-cache fluentd \
    && gem install fluent-plugin-forward fluent-plugin-json

# Crear directorios necesarios para Fluentd
RUN mkdir -p /fluentd/log /fluentd/etc

# Copiar configuración de Fluentd
COPY fluentd.conf /fluentd/etc/fluentd.conf

# Exponer los puertos utilizados por HyperDX y Fluentd
EXPOSE 8000 4318 4317 8080 8002 24225

# Definir variables de entorno con valores por defecto
ENV HDX_API_KEY=${HDX_API_KEY:-"default-api-key"}
ENV FLUENTD_ADDRESS=${FLUENTD_ADDRESS:-"tls://in-otel.hyperdx.io:24225"}
ENV SERVICE_NAME=${SERVICE_NAME:-"my_docker_service"}

# Etiquetas necesarias para HyperDX
LABEL __HDX_API_KEY=$HDX_API_KEY
LABEL service.name=$SERVICE_NAME

# Iniciar Fluentd en paralelo con HyperDX
CMD sh -c "fluentd -c /fluentd/etc/fluentd.conf & hyperdx-local"
