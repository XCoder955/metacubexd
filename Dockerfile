FROM docker.io/node:alpine AS builder

USER root
ENV PNPM_HOME=/pnpm
ENV PATH=$PNPM_HOME:$PATH
ENV HUSKY=0
WORKDIR /build

COPY . .

RUN npm install --force -g corepack
RUN corepack enable
RUN corepack install
RUN pnpm install
RUN pnpm build

FROM metacubex/mihomo:latest

ENV PORT=80
ENV VITE_MIHOMO_PORT=9090
EXPOSE 80

WORKDIR /app
RUN apk add nodejs
# Copy the entire Nuxt server output
COPY --from=builder /build/.output ./metacubex

ENTRYPOINT node /app/metacubex/server/index.mjs & && /mihomo