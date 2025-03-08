# Usa la imagen oficial de Fluentd con soporte para plugins
FROM fluent/fluentd:v1.14-1 AS fluentd

# Instalar plugins necesarios en Fluentd
USER root
RUN gem install fluent-plugin-forward fluent-plugin-json --no-document

# Copiar la configuración de Fluentd
COPY fluentd.conf /fluentd/etc/

# Usa la imagen base de HyperDX Local
FROM hyperdx/hyperdx-local:latest

# Copiar Fluentd desde la primera etapa de compilación
COPY --from=fluentd /fluentd /fluentd

# Exponer los puertos utilizados por HyperDX y Fluentd
EXPOSE 8000 4318 4317 8080 8002 24225

# Configurar variables de entorno con valores por defecto
ENV HDX_API_KEY=${HDX_API_KEY:-"default-api-key"}
ENV FLUENTD_ADDRESS=${FLUENTD_ADDRESS:-"tls://in-otel.hyperdx.io:24225"}
ENV SERVICE_NAME=${SERVICE_NAME:-"my_docker_service"}

# Etiquetas necesarias para HyperDX
LABEL __HDX_API_KEY=$HDX_API_KEY
LABEL service.name=$SERVICE_NAME

# Comando de inicio: primero Fluentd y luego HyperDX
CMD sh -c "fluentd -c /fluentd/etc/fluentd.conf & hyperdx-local"
