# Dockerfile para un proyecto de Python con Poetry
# Este Dockerfile está optimizado para un entorno de desarrollo y producción
FROM python:3.11-slim as base

# Configuraciones esenciales
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PIP_DEFAULT_TIMEOUT 100
ENV PIP_DISABLE_PIP_VERSION_CHECK 1

WORKDIR /app

# Instalar dependencias del sistema solo las esenciales
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Capa de dependencias (caché eficiente)
COPY pyproject.toml .
RUN pip install --no-cache-dir poetry && \
    poetry config virtualenvs.create false && \
    poetry install --no-root --only main

# Copiar el proyecto
COPY . .

# Capa de desarrollo (solo para desarrollo)
FROM base as dev
RUN poetry install --no-root

# Comando por defecto (sobrescribir en docker-compose)
CMD ["python", "src/main.py"]