# build react app
FROM node:latest AS builder

WORKDIR /app

COPY . .

RUN npm install --package-lock && npm run build

FROM nginx:1.21.5-alpine

WORKDIR /usr/share/nginx/html

RUN rm -rf ./*

COPY --from=builder /app/build .

COPY ./nginx/phalanx.conf /etc/nginx/conf.d/phalanx.conf
COPY ./nginx/phalanx-ssl.conf /etc/nginx/conf.d/phalanx-ssl.conf

EXPOSE 80:443

CMD ["nginx", "-g", "daemon off;"]


# FROM node:latest
# WORKDIR /app

# COPY . .
# RUN yarn install
# EXPOSE 3000

# CMD ["yarn", "start"]
