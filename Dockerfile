FROM debian:9

# Labels
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/momoyama-south-gate/cstrike-docker"

# Define default env variables
ENV PORT 27015
ENV MAP de_dust2
ENV MAXPLAYERS 16
ENV SV_LAN 0

# Install dependencies
RUN dpkg --add-architecture i386
RUN apt-get update && \
    apt-get -qqy install lib32gcc1 curl

# Create directories
WORKDIR /root
RUN mkdir Steam .steam

# Download steamcmd
WORKDIR /root/Steam
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

# Install CS:CZ via steamcmd
RUN ./steamcmd.sh +login anonymous +app_set_config 90 mod czero +quit || true
RUN ./steamcmd.sh +login anonymous +force_install_dir /hlds +app_update 90 validate +quit || true
RUN ./steamcmd.sh +login anonymous +app_update 80 validate +quit || true
RUN ./steamcmd.sh +login anonymous +app_update 10 validate +quit || true
RUN ./steamcmd.sh +login anonymous +force_install_dir /hlds +app_update 90 validate +quit

# Link sdk
WORKDIR /root/.steam
RUN ln -s ../Steam/linux32 sdk32

# Create start map file
WORKDIR /hlds
RUN echo $MAP > czero/start_map.txt

# Start server
WORKDIR /hlds
ENTRYPOINT ./hlds_run -game czero -strictportbind -ip 0.0.0.0 -port $PORT +sv_lan $SV_LAN +map $(cat czero/start_map.txt) -maxplayers $MAXPLAYERS
