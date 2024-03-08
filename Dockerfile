FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/kozakdenys/qr-code-styling-site.git && \
    cd qr-code-styling-site && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:16-alpine AS build

WORKDIR /qr-code-styling-site
COPY --from=base /git/qr-code-styling-site .
RUN npm install && \
    npm run build

FROM pierrezemb/gostatic

COPY --from=build /qr-code-styling-site/docs /srv/http
EXPOSE 8043
