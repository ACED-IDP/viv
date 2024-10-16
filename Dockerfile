FROM node:20-slim

RUN apt-get update && apt-get install -y git vim curl jq

WORKDIR /app

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable


ADD "https://api.github.com/repos/ACED-IDP/viv/commits?per_page=1" latest_commit
WORKDIR /app/viv
ADD . .

RUN pnpm install

EXPOSE 8000
CMD [ "pnpm", "start" ]