FROM node:18.20-alpine

ARG N8N_VERSION=1.50.1

# Instala as dependências necessárias para n8n e Puppeteer
RUN apk add --update --no-cache \
    graphicsmagick \
    tzdata \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont

USER root

# Configura as variáveis de ambiente para o Puppeteer
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Instala n8n e Puppeteer
RUN apk --update add --virtual build-dependencies python3 build-base && \
    npm_config_user=root npm install --location=global n8n@${N8N_VERSION} puppeteer && \
    apk del build-dependencies

WORKDIR /data
RUN npm install puppeteer

EXPOSE $PORT

ENV N8N_USER_ID=root

CMD export N8N_PORT=$PORT && n8n start