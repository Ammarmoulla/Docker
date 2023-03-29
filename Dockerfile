FROM node:14 as base

FROM base as development

WORKDIR /code

COPY package.json .

# ARG NODE_ENV

# RUN if ["$NODE_ENV" == "production"]; \
#     then npm install --only=production; \
#     else npm install; \
#     fi

RUN npm install

COPY . .

EXPOSE 3000

CMD [ "npm", "run", "start-dev"]

FROM base as production

WORKDIR /code

COPY package.json .

RUN npm install --only=production

COPY . .

EXPOSE 3000

CMD [ "npm", "start"]