FROM sonots/docker-ruby

MAINTAINER Naoki AINOYA <ainonic@gmail.com>

WORKDIR /data

RUN bash -lc 'rbenv global 2.1'

RUN yum -y install mysql-devel --enablerepo=remi
RUN yum install -y bison
RUN yum install -y gcc-c++
RUN yum install -y git
RUN yum install -y glibc-headers
RUN yum install -y hiredis-devel
RUN yum install -y httpd
RUN yum install -y httpd-devel
RUN yum install -y libyaml-devel
RUN yum install -y openssl-devel
RUN yum install -y readline
RUN yum install -y readline-devel
RUN yum install -y tar
RUN yum install -y zlib
RUN yum install -y zlib-devel
RUN yum install -y pcre
RUN yum install -y pcre-devel

# Install ngx_mruby
RUN bash -lc 'export PATH=/usr/local/bin:$PATH'

RUN ln -s ~/.rbenv/shims/ruby /usr/local/bin/ruby
RUN ln -s ~/.rbenv/shims/rake /usr/local/bin/rake

RUN cd /usr/local/src/ && git clone https://github.com/matsumoto-r/ngx_mruby.git
ENV NGINX_CONFIG_OPT_ENV --with-http_stub_status_module --prefix=/usr/local/nginx
ADD conf/build_config.rb /usr/local/src/ngx_mruby/build_config.rb
RUN cd /usr/local/src/ngx_mruby && sh build.sh && make install

# Copy the Gemfile and Gemfile.lock into the image. 
# Temporarily set the working directory to where they are. 
WORKDIR /tmp/hello
ADD hello/Gemfile Gemfile
ADD hello/Gemfile.lock Gemfile.lock
RUN bash -lc 'bundle install'
ADD hello /data/hello

WORKDIR /tmp/takt
ADD takt/Gemfile Gemfile
ADD takt/Gemfile.lock Gemfile.lock
RUN bash -lc 'bundle install'
ADD takt /data/takt

ADD hook /usr/local/nginx/hook
ADD conf/nginx.conf /usr/local/nginx/conf/nginx.conf

ADD scripts /data/scripts

WORKDIR /data/hello
RUN mkdir -p tmp/{log,pids}

WORKDIR /data/takt
RUN mkdir -p log tmp/{log,pids}

ENV REDIS_HOST 127.0.0.1
ENV REDIS_PORT 6379

WORKDIR /data/hello
CMD bash -lc /data/scripts/start.sh
