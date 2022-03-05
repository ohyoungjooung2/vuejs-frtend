FROM node:lts-alpine as builder
# Make the 'app' folder the current working directory
WORKDIR /app
#copy both package.json and package-lock.json 
COPY package*.json ./
#Install project dependencies leaving out dev dependencies
RUN npm install --production
#copy project files and folders to the current working directory (i.e. 'app' folder)
COPY . .
#build app for production with minification
RUN npm run build

#nginx production
FROM nginx:stable-alpine as production-stg
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx","-g","daemon off;"]

