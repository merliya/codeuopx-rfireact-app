# Root node image to prebuild (code name https://github.com/nodejs/Release#release-schedule)
# Using multi-staging layers to cache node_modules
# https://docs.docker.com/develop/develop-images/multistage-build/
# Erbium if we go to 12.x
FROM 050853773894.dkr.ecr.us-east-1.amazonaws.com/edu-node-base:release as root
WORKDIR /rfi-react-app

# Read the build parameters
ARG CODEARTIFACT_AUTH_TOKEN
ARG AWS_ACCOUNT
ARG AWS_REGION

# Set registry name
RUN npm config set registry=https://uop-domain-$AWS_ACCOUNT.d.codeartifact.$AWS_REGION.amazonaws.com/npm/uop-node-repo/
# Set auth token
RUN npm config set //uop-domain-$AWS_ACCOUNT.d.codeartifact.$AWS_REGION.amazonaws.com/npm/uop-node-repo/:_authToken=$CODEARTIFACT_AUTH_TOKEN
RUN npm config set //uop-domain-$AWS_ACCOUNT.d.codeartifact.$AWS_REGION.amazonaws.com/npm/uop-node-repo/:always-auth=true

# Pull package.json and package-lock.json and install all dependencies
FROM root AS dependencies
COPY package*.json ./
RUN npm install

# Build out static content and copy over build
FROM dependencies AS uibuild
WORKDIR /rfi-react-app
COPY . ./
RUN npm run build

# Run unit tests
ENV CI=true
RUN npm run test

# Host and serve app
FROM 050853773894.dkr.ecr.us-east-1.amazonaws.com/edu-node-base:release
WORKDIR /rfi-react-app
ENV PATH /rfi-react-app/node_modules/.bin:$PATH
COPY --from=uibuild /rfi-react-app/package*.json ./
COPY --from=uibuild /rfi-react-app/deployment.yaml ./
COPY --from=uibuild /rfi-react-app/.env ./
COPY --from=uibuild /rfi-react-app/newrelic.js ./

# Read the build parameters
ARG CODEARTIFACT_AUTH_TOKEN
ARG AWS_ACCOUNT
ARG AWS_REGION

# Set registry name
RUN npm config set registry=https://uop-domain-$AWS_ACCOUNT.d.codeartifact.$AWS_REGION.amazonaws.com/npm/uop-node-repo/
# Set auth token
RUN npm config set //uop-domain-$AWS_ACCOUNT.d.codeartifact.$AWS_REGION.amazonaws.com/npm/uop-node-repo/:_authToken=$CODEARTIFACT_AUTH_TOKEN
RUN npm config set //uop-domain-$AWS_ACCOUNT.d.codeartifact.$AWS_REGION.amazonaws.com/npm/uop-node-repo/:always-auth=true

# Only install modules needed to run production code (node server)
RUN npm install --only=production

# Copy our main assets to run
COPY --from=uibuild /rfi-react-app/build ./build
COPY --from=uibuild /rfi-react-app/build/static ./build/request/static
COPY --from=uibuild /rfi-react-app/server ./server

# Run our NPM command which will refresh the env config
CMD ["npm", "run", "deploy"]
EXPOSE 8080
