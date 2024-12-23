# syntax=docker/dockerfile:1
FROM debian:stable-slim
EXPOSE 80/udp
EXPOSE 80/tcp
RUN apt-get update && apt-get install -y wget xz-utils unzip bash curl
RUN curl -s https://api.github.com/repos/thepeacockproject/Peacock/releases/latest \
    | grep "browser_download_url.*zip" | grep -E "linux"\
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -q -O Peacock.zip -i -
RUN unzip -q Peacock.zip \
    && rm Peacock.zip \
    && mv Peacock-* Peacock/
RUN wget -q -O node.tar.xz https://nodejs.org/dist/v22.12.0/node-v22.12.0-linux-x64.tar.xz
RUN tar -xf node.tar.xz --directory Peacock \
    && mv ./Peacock/node-v22.12.0-linux-x64 ./Peacock/node \
    && rm node.tar.xz
WORKDIR /Peacock
RUN mkdir {userdata,contractSessions}
COPY ["start_server.sh", "start_server.sh"]
RUN chmod a+x start_server.sh
CMD ["./start_server.sh"]

VOLUME /Peacock/userdata
VOLUME /Peacock/contractSessions