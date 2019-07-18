FROM node:10.16.0-alpine AS build
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install
COPY public ./public/
COPY src ./src/
RUN yarn build

FROM nginx:1.17.1-alpine AS runtime
COPY --from=build /app/build /var/www/
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
ENTRYPOINT ["nginx","-g","daemon off;"]
