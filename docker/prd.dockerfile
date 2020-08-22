# Imagen docker front / back para videochat
FROM node:lts-alpine3.11 as ggRooms

WORKDIR /openvidu-call

ARG BRANCH_NAME=master
ARG BASE_HREF=/

RUN apk add wget unzip

# Clon desde github ggRooms-v3 (rama master), despliegue en prd
# RUN git clone "https://github.com/gustavoarielaltamirano/ggRooms-v3.git" . && \
# Download openvidu-call from specific branch (master by default), intall openvidu-browser and build for production
RUN wget "https://github.com/gustavoarielaltamirano/ggRooms-v3/raw/master/archive/openvidu-call-master.zip" -O openvidu-call.zip && \
    unzip openvidu-call.zip && \
    rm openvidu-call.zip && \
    # mv openvidu-call-master/openvidu-call-front/ . && \
    # mv openvidu-call-master/openvidu-call-back/ . && \
    # rm openvidu-call-front/package-lock.json && \
    # rm openvidu-call-back/package-lock.json && \
    # rm -rf openvidu-call-master && \
    # Instala dependencias para el front y despliega en prd
    npm i --prefix openvidu-call-front && \
    npm run build-prod master --prefix openvidu-call-front && \
    rm -rf openvidu-call-front && \
    # Instala dependencias para el back y construye el despliegue en prd
    npm i --prefix openvidu-call-back && \
    npm run build --prefix openvidu-call-back && \
    mv openvidu-call-back/dist . && \
    rm -rf openvidu-call-back


FROM node:lts-alpine3.11

WORKDIR /opt/openvidu-call

COPY --from=ggRooms /openvidu-call/dist .
# Entrypoint
COPY ./entrypoint.sh /usr/local/bin
RUN apk add curl && \
    chmod +x /usr/local/bin/entrypoint.sh && \
    npm install -g nodemon

# CMD /usr/local/bin/entrypoint.sh
CMD ["/usr/local/bin/entrypoint.sh"]
