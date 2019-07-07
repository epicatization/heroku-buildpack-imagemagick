FROM heroku/heroku:18
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
  build-essential \
  autoconf \
  automake \
  libtool \
  intltool \
  gtk-doc-tools \
  unzip \
  wget \
  git \
  pkg-config\
  glib-2.0-dev \
  libexpat-dev \
  librsvg2-dev \
  libpng-dev \
  libjpeg-dev \
  libtiff5-dev \
  libexif-dev \
  liblcms2-dev \
  libxml2-dev \
  libfftw3-dev \
  libheif-dev \
  libpoppler-glib-dev

RUN cd /usr/src/ \
  && git clone https://github.com/strukturag/libde265.git  \
  && git clone https://github.com/strukturag/libheif.git

RUN cd /usr/src/libde265 \
  && ./autogen.sh \
  && ./configure \
  && make  \
  && make install

RUN cd /usr/src/libheif \
  && ./autogen.sh \
  && ./configure \
  && make \
  && make install

RUN cd /usr/src/ \
  && wget https://www.imagemagick.org/download/ImageMagick.tar.gz \
  && tar xf ImageMagick.tar.gz \
  && cd ImageMagick-7* \
  && ./configure --with-heic=yes --prefix=/usr/src/imagemagick \
  && make \
  && make install

RUN cp /usr/local/lib/libde265.so.0 /usr/src/imagemagick/lib \
  && cp /usr/local/lib/libheif.so.1 /usr/src/imagemagick/lib

# clean the build area ready for packaging
RUN cd /usr/src/imagemagick \
  && strip lib/*.a lib/lib*.so*

RUN cd /usr/src/imagemagick \
  && rm -rf build \
  && mkdir build \
  && tar czf \
  /usr/src/imagemagick/build/imagemagick.tar.gz bin include lib
