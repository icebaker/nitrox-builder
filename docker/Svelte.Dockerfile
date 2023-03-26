FROM node:19.7.0-buster-slim AS builder
COPY ./nitrox-{SERVICE} /nitrox/service/nitrox-{SERVICE}
RUN rm -rf /nitrox/service/nitrox-{SERVICE}/.env && touch /nitrox/service/nitrox-{SERVICE}/.env
WORKDIR /nitrox/service/nitrox-{SERVICE}
RUN npm run build

FROM node:19.7.0-buster-slim
COPY --from=builder /nitrox/service/nitrox-{SERVICE} /nitrox/service/nitrox-{SERVICE}
RUN chown -R 1000 /nitrox/service/nitrox-{SERVICE}
USER 1000
WORKDIR /nitrox/service/nitrox-{SERVICE}
CMD ["bash", "./init.sh"]
