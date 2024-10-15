FROM node:20-slim AS base

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

FROM base AS prod

COPY pnpm-lock.yaml /app
WORKDIR /app
RUN pnpm fetch --prod

ADD "https://api.github.com/repos/ACED-IDP/viv/commits?per_page=1" latest_commit

RUN git clone  https://github.com/ACED-IDP/viv.git
WORKDIR /app/viv
RUN git checkout feature/signed-urls
RUN pnpm run build

FROM base
COPY --from=prod /app/node_modules /app/node_modules
COPY --from=prod /app/dist /app/dist
EXPOSE 8000
CMD [ "pnpm", "start" ]