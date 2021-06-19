FROM ubuntu:18.04

ARG aws_default_region=''
ARG aws_access_key=''
ARG aws_secret_access_key=''

ENV AWS_REGION=${aws_default_region}
ENV AWS_ACCESS_KEY=${aws_access_key}
ENV AWS_SECRET_ACCESS_KEY=${aws_secret_access_key}

ARG LISA_START=1
ARG LISA_END=500

ENV RUN_START=${LISA_START}
ENV RUN_END=${LISA_END}

# Install dev environment
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y -q apt-utils

RUN apt-get install -y -q \
    build-essential \
    autoconf \
    automake \
    cmake \
    zip \
    unzip \
    git \
    wget \
    vim \
    awscli \
    postgresql-10 \
    postgresql-contrib-10 \
    postgresql-server-dev-10
    #gdal-bin postgresql-10-postgis-2.4 postgresql-10-postgis-scripts postgis

# Setting PostgreSQL
RUN sed -i 's/\(peer\|md5\)/trust/' /etc/postgresql/10/main/pg_hba.conf && \
    service postgresql start && \
    createuser publicuser --no-createrole --no-createdb --no-superuser -U postgres && \
    service postgresql stop

# Copy the current directory contents into the container at WORKDIR
COPY . /tmp

# build libgeoda
RUN cd /tmp && chmod +x *.sh && \
    git clone -b big --recursive https://github.com/geodacenter/postgeoda && \
    cd postgeoda && \
    mkdir -p build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make && \
    make install

# install postgeoda
RUN service postgresql start && /bin/su postgres -c \
      /tmp/install_postgeoda.sh && service postgresql stop

# download data
RUN cd /tmp && ./download_data.sh

# create table
RUN service postgresql start && /bin/su postgres -c \
      /tmp/create_table.sh 

CMD ["sh", "-c", "service postgresql start && /bin/su postgres -c /tmp/run.sh"]
 