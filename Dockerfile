FROM node:10.16.0-alpine AS build
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install
COPY public ./public/
COPY src ./src/
RUN yarn build

FROM nginx:1.17.1-alpine AS runtime
RUN apk add --no-cache bash
WORKDIR /home
COPY --from=build /app/build /var/www/
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY build-config.sh .env ./
RUN chmod +x ./build-config.sh
EXPOSE 80
ENTRYPOINT ["/bin/bash", "-c", "./build-config.sh && cp ./env-config.js /var/www/ && nginx -g \"daemon off;\""]
