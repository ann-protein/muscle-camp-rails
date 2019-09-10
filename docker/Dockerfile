# Ruby images
FROM phusion/passenger-ruby26:latest

# Using Nginx and Passenger
RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default

# Configuring Nginx
ADD nginx/webapp.conf /etc/nginx/sites-enabled/webapp.conf
#ADD nginx/secret_key.conf /etc/nginx/main.d/secret_key.conf
ADD nginx/gzip_max.conf /etc/nginx/conf.d/gzip_max.conf

# Set correct environment variables.
ENV RAILS_ENV production

# gitのインストール
RUN apt-get update && apt-get install -y \
  git

# gitからclone
WORKDIR /home/app
RUN git clone -b feature/deployment_mysql_docker https://github.com/ann-protein/muscle-camp-rails.git

ADD master.key /home/app/muscle-camp-rails/config/master.key

# bundlerのインストール
RUN gem install bundler

# tzdataのインストール
RUN apt-get update && apt-get install -y \
  tzdata

# タイムゾーンをJSTに設定
ENV TZ=Asia/Tokyo

# bundle install
WORKDIR /home/app/muscle-camp-rails
RUN bundle install

# ポート開放
EXPOSE 80

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]