FROM node:20-slim

ARG GITHUB_SHA
ENV GITHUB_SHA=$GITHUB_SHA

# add common utilities
RUN apt-get update && apt-get install -y git vim curl jq

# setup pnpm
WORKDIR /app

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

# setup app dir
WORKDIR /app/viv
# write git commit hash to a file
RUN echo $GITHUB_SHA > git_commit_hash.txt

# Copy the rest of the project files into the container
ADD . .

# install
RUN pnpm install

# Expose the port your app listens on
EXPOSE 8000

# Note - actual command is in the helm chart
CMD [ "pnpm", "start" ]