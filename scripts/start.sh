#!/bin/sh
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
rbenv local 2.1 && ruby -v

/usr/local/bin/redis-server /etc/redis.conf

/usr/local/nginx/sbin/nginx &

cd /data/hello
bundle exec unicorn -c config/unicorn.rb -l 0.0.0.0:8080 &

cd /data/takt
bundle exec unicorn -c config/unicorn.rb -l 0.0.0.0:3000 &

tail -F /usr/local/nginx/logs/access.log &
tail -F /usr/local/nginx/logs/error.log &
tail -F /data/hello/log/stderr.log &
tail -F /data/hello/log/stdout.log &
tail -F /data/takt/log/stderr.log &
tail -F /data/takt/log/stdout.log

