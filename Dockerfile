FROM ruby:2.7.2-alpine3.12 as base
RUN echo "http://mirrors.ustc.edu.cn/alpine/v3.12/main/" > /etc/apk/repositories && \
    echo "http://mirrors.ustc.edu.cn/alpine/v3.12/community/" >> /etc/apk/repositories
WORKDIR /app
RUN apk add --no-cache tzdata libpq git && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

FROM base as bundler
RUN apk add --no-cache autoconf automake build-base postgresql-dev
COPY Gemfile .
COPY Gemfile.lock .
RUN echo 'gem: --no-document' >> ~/.gemrc && \
    cp ~/.gemrc /etc/gemrc && \
    chmod +r /etc/gemrc && \
    bundle config mirror.https://rubygems.org https://gems.ruby-china.com && \
    bundle config set without 'development test' && \
    bundle install -j 4 -r 3

FROM base as release
COPY --from=bundler /usr/local/bundle/ /usr/local/bundle/
COPY . .
RUN sed "s/^\([^ ]* *[^ ]* *[^ ]* *[^ ]* *[^ ]* *\)\(.*\)/\1cd \/app;rails runner \"\2\"/" config/cronjobs_rails >> config/cronjobs && \
    sed 's;\(.*\)$;\1 2>\&1 | tee -a /app/log/cronjobs.log;' config/cronjobs | crontab -
ENV RAILS_ENV production
ENTRYPOINT ["sh",  "bin/entrypoint.sh"]
CMD ["bundle", "exec", "puma"]
