FROM node:18

WORKDIR /app

COPY app/package*.json ./
RUN npm install

COPY app/ .

EXPOSE 10101
CMD ["npm", "start"]
