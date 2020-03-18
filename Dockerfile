FROM debian:10.3-slim

ARG VERSION=80.0.3987.132-1.buster1
ARG DOWNLOAD=https://github.com/Eloston/ungoogled-chromium-binaries/releases/download
COPY shas.txt /
COPY sources.list /etc/apt/sources.list
RUN true && \
    apt-get -o Acquire::Check-Valid-Until=false update && \
    apt-get -y --no-install-recommends install \
      wget=1.20.1-1.1 \
      ca-certificates=20190110 \
      x11-utils=7.7+4 \
      xdg-utils=1.1.3-1 \
      libasound2=1.1.8-1 \
      libatk-bridge2.0-0=2.30.0-5 \
      libatk1.0-0=2.30.0-2 \
      libatspi2.0-0=2.30.0-7 \
      libavcodec58=7:4.1.4-1~deb10u1 \
      libavformat58=7:4.1.4-1~deb10u1 \
      libavutil56=7:4.1.4-1~deb10u1 \
      libcairo2=1.16.0-4 \
      libcups2=2.2.10-6+deb10u2 \
      libdbus-1-3=1.12.16-1 \
      libevent-2.1-6=2.1.8-stable-4 \
      libflac8=1.3.2-3 \
      libgdk-pixbuf2.0-0=2.38.1+dfsg-1 \
      libglib2.0-0=2.58.3-2+deb10u2 \
      libgtk-3-0=3.24.5-1 \
      libharfbuzz0b=2.3.1-1 \
      libicu63=63.1-6 \
      libjpeg62-turbo=1:1.5.2-2+b1 \
      libjsoncpp1=1.7.4-3 \
      liblcms2-2=2.9-3 \
      libminizip1=1.1-8+b1 \
      libnspr4=2:4.20-1 \
      libnss3=2:3.42.1-1+deb10u2 \
      libopenjp2-7=2.3.0-2+deb10u1 \
      libopus0=1.3-1 \
      libpango-1.0-0=1.42.4-7~deb10u1 \
      libpangocairo-1.0-0=1.42.4-7~deb10u1 \
      libpulse0=12.2-4+deb10u1 \
      libsnappy1v5=1.1.7-1 \
      libvpx5=1.7.0-3+deb10u1 \
      libwebp6=0.6.1-2 \
      libwebpdemux2=0.6.1-2 \
      libwebpmux3=0.6.1-2 \
      libxcursor1=1:1.1.15-2 \
      libxml2=2.9.4+dfsg1-7+b3 \
      libxslt1.1=1.1.32-2.2~deb10u1 \
      libxss1=1:1.2.3-1 \
      fonts-symbola=2.60-1 \
      libcanberra-gtk3-0=0.30-7 \
      i965-va-driver=2.3.0+dfsg1-1 \
      && \
    wget "${DOWNLOAD}"/"${VERSION}"/ungoogled-chromium-common_"${VERSION}"_amd64.deb && \
    wget "${DOWNLOAD}"/"${VERSION}"/ungoogled-chromium-dbgsym_"${VERSION}"_amd64.deb && \
    wget "${DOWNLOAD}"/"${VERSION}"/ungoogled-chromium-driver-dbgsym_"${VERSION}"_amd64.deb && \
    wget "${DOWNLOAD}"/"${VERSION}"/ungoogled-chromium-driver_"${VERSION}"_amd64.deb && \
    wget "${DOWNLOAD}"/"${VERSION}"/ungoogled-chromium-l10n_"${VERSION}"_all.deb && \
    wget "${DOWNLOAD}"/"${VERSION}"/ungoogled-chromium-sandbox-dbgsym_"${VERSION}"_amd64.deb && \
    wget "${DOWNLOAD}"/"${VERSION}"/ungoogled-chromium-sandbox_"${VERSION}"_amd64.deb && \
    wget "${DOWNLOAD}"/"${VERSION}"/ungoogled-chromium-shell-dbgsym_"${VERSION}"_amd64.deb && \
    wget "${DOWNLOAD}"/"${VERSION}"/ungoogled-chromium-shell_"${VERSION}"_amd64.deb && \
    wget "${DOWNLOAD}"/"${VERSION}"/ungoogled-chromium_"${VERSION}"_amd64.buildinfo && \
    wget "${DOWNLOAD}"/"${VERSION}"/ungoogled-chromium_"${VERSION}"_amd64.changes && \
    wget "${DOWNLOAD}"/"${VERSION}"/ungoogled-chromium_"${VERSION}"_amd64.deb && \
    sha256sum -c shas.txt && \
    rm shas.txt && \
    dpkg -i ungoogled-chromium_*.deb ungoogled-chromium-common_*.deb && \
    apt-get -y remove wget && \
    apt-get -y autoremove && \
    rm ungoogled-chromium* && \
    rm -rf /var/lib/apt/lists/*

# Add user: we pick 1000 for uid/gid because in actual docker, on actual
# debian-based systems, this is the most common "first user" and therefore
# most likely to match up with the host when you mount in other stuff
RUN groupadd -g 1000 -r user && useradd -u 1000 -r -g user -G audio,video user \
    && mkdir -p /home/user && chown -R user:user /home/user
WORKDIR /home/user
USER user
ENV HOME=/home/user

ENTRYPOINT ["/usr/bin/chromium", "--no-sandbox"]
