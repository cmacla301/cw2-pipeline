FROM node:16
WORKDIR /usr/src/app
COPY server.js .
EXPOSE 8081
CMD ["node", "server.js"]
