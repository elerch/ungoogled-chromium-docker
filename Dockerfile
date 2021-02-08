FROM debian:10.7-slim
ARG VERSION=83.0.4103.116-1
# https://download.opensuse.org/repositories/home:/ungoogled_chromium/Debian_Buster/amd64/ungoogled-chromium-common_83.0.4103.116-1.buster2_amd64.deb
# https://download.opensuse.org/repositories/home:/ungoogled_chromium/Debian_Buster/all/ungoogled-chromium-l10n_83.0.4103.116-1.buster2_all.deb
ARG PREFIX=https://download.opensuse.org/repositories/home:/ungoogled_chromium/Debian_Buster/amd64/ungoogled-chromium
ARG SUFFIX=.buster1_amd64.deb
COPY sources.list /etc/apt/sources.list
RUN true && \
    apt-get -o Acquire::Check-Valid-Until=false update && \
    apt-get -y --no-install-recommends install \
      wget=1.20.1-1.1 \
      ca-certificates=20200601~deb10u1 \
      x11-utils=7.7+4 \
      xdg-utils=1.1.3-1+deb10u1 \
      libasound2=1.1.8-1 \
      libatk-bridge2.0-0=2.30.0-5 \
      libatk1.0-0=2.30.0-2 \
      libatspi2.0-0=2.30.0-7 \
      libavcodec58=7:4.1.6-1~deb10u1 \
      libavformat58=7:4.1.6-1~deb10u1 \
      libavutil56=7:4.1.6-1~deb10u1 \
      libcairo2=1.16.0-4 \
      libcups2=2.2.10-6+deb10u4 \
      libdbus-1-3=1.12.20-0+deb10u1 \
      libevent-2.1-6=2.1.8-stable-4 \
      libflac8=1.3.2-3 \
      libgdk-pixbuf2.0-0=2.38.1+dfsg-1 \
      libglib2.0-0=2.58.3-2+deb10u2 \
      libgtk-3-0=3.24.5-1 \
      libharfbuzz0b=2.3.1-1 \
      libicu63=63.1-6+deb10u1 \
      libjpeg62-turbo=1:1.5.2-2+deb10u1 \
      libjsoncpp1=1.7.4-3 \
      liblcms2-2=2.9-3 \
      libminizip1=1.1-8+b1 \
      libnspr4=2:4.20-1 \
      libnss3=2:3.42.1-1+deb10u3 \
      libopenjp2-7=2.3.0-2+deb10u1 \
      libopus0=1.3-1 \
      libpango-1.0-0=1.42.4-8~deb10u1 \
      libpangocairo-1.0-0=1.42.4-8~deb10u1 \
      libpulse0=12.2-4+deb10u1 \
      libsnappy1v5=1.1.7-1 \
      libvpx5=1.7.0-3+deb10u1 \
      libwebp6=0.6.1-2 \
      libwebpdemux2=0.6.1-2 \
      libwebpmux3=0.6.1-2 \
      libxcursor1=1:1.1.15-2 \
      libxml2=2.9.4+dfsg1-7+deb10u1 \
      libxslt1.1=1.1.32-2.2~deb10u1 \
      libxss1=1:1.2.3-1 \
      fonts-symbola=2.60-1 \
      libcanberra-gtk3-0=0.30-7 \
      i965-va-driver=2.3.0+dfsg1-1 \
      libgbm1=18.3.6-2+deb10u1 \
      libre2-5=20190101+dfsg-2 \
      libatomic1=8.3.0-6 \
      && \
    wget --progress=dot "${PREFIX}_${VERSION}${SUFFIX}" && \
    wget --progress=dot "${PREFIX}-common_${VERSION}${SUFFIX}" && \
    wget --progress=dot "${PREFIX}-dbgsym_${VERSION}${SUFFIX}" && \
    wget --progress=dot "${PREFIX}-driver-dbgsym_${VERSION}${SUFFIX}" && \
    wget --progress=dot "${PREFIX}-driver_${VERSION}${SUFFIX}" && \
    wget --progress=dot "https://download.opensuse.org/repositories/home:/ungoogled_chromium/Debian_Buster/all/ungoogled-chromium-l10n_${VERSION}.buster1_all.deb" && \
    wget --progress=dot "${PREFIX}-sandbox_${VERSION}${SUFFIX}" && \
    wget --progress=dot "${PREFIX}-shell-dbgsym_${VERSION}${SUFFIX}" && \
    wget --progress=dot "${PREFIX}-shell_${VERSION}${SUFFIX}" && \
    dpkg -i ungoogled-chromium*.deb && \
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
