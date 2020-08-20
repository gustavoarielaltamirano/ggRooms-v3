# Imagen docker front / back para videochat
FROM node:lts-alpine3.11 as openvidu-call-build

WORKDIR /openvidu-call

ARG BRANCH_NAME=master
ARG BASE_HREF=/

RUN apk add wget unzip git

# Clon desde github ggRooms-v3 (rama master), despliegue en prd
RUN git clone "https://github.com/gustavoarielaltamirano/ggRooms-v3.git" . && \
    # Instala dependencias para el front y despliega en prd
    npm i --prefix openvidu-call-front && \
    npm run build-prod ${BASE_HREF} --prefix openvidu-call-front && \
    rm -rf openvidu-call-front && \
    # Instala dependencias para el back y construye el despliegue en prd
    npm i --prefix openvidu-call-back && \
    npm run build --prefix openvidu-call-back && \
    mv openvidu-call-back/dist . && \
    rm -rf openvidu-call-back


FROM node:lts-alpine3.11

WORKDIR /opt/openvidu-call

COPY --from=openvidu-call-build /openvidu-call/dist .
# Entrypoint
COPY ./entrypoint.sh /usr/local/bin
RUN apk add curl && \
    chmod +x /usr/local/bin/entrypoint.sh && \
    npm install -g nodemon

# CMD /usr/local/bin/entrypoint.sh
CMD ["/usr/local/bin/entrypoint.sh"]
