FROM node:19-alpine

WORKDIR /home/node/
COPY app/ .

RUN npm install

ENTRYPOINT npm start

