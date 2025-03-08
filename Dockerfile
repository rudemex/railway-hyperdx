# Usa la imagen oficial de HyperDX Local
FROM hyperdx/hyperdx-local:latest

# Exponer los puertos utilizados por HyperDX
EXPOSE 8000 4318 4317 8080 8002

# Configurar variables de entorno con valores por defecto
ENV HDX_API_KEY=${HDX_API_KEY:-"default-api-key"}
ENV SERVICE_NAME=${SERVICE_NAME:-"my_service"}
ENV OTEL_EXPORTER_OTLP_ENDPOINT=${OTEL_EXPORTER_OTLP_ENDPOINT:-"http://localhost:4318"}

# Etiquetas necesarias para HyperDX
LABEL __HDX_API_KEY=$HDX_API_KEY
LABEL service.name=$SERVICE_NAME

# Comando de inicio
CMD ["hyperdx-local"]
