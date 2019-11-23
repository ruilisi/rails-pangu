FROM ruby:2.6.5-alpine3.10 as base
RUN echo "http://mirrors.ustc.edu.cn/alpine/v3.10/main/" > /etc/apk/repositories && \
    echo "http://mirrors.ustc.edu.cn/alpine/v3.10/community/" >> /etc/apk/repositories
WORKDIR /usr/src/app
RUN apk add --no-cache tzdata libpq git && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

FROM base as bundler
RUN apk add --no-cache autoconf automake build-base postgresql-dev
COPY Gemfile.core .
RUN echo 'gem: --no-document' >> ~/.gemrc && \
    cp ~/.gemrc /etc/gemrc && \
    chmod +r /etc/gemrc && \
    bundle config mirror.https://rubygems.org https://gems.ruby-china.com && \
    bundle install --gemfile Gemfile.core -j16 --binstubs=$BUNDLE_PATH/bin

COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install --gemfile Gemfile -j16 --binstubs=$BUNDLE_PATH/bin

FROM base as release
COPY --from=bundler /usr/local/bundle/ /usr/local/bundle/
COPY . .
RUN ruby bin/gen_cronjobs.rb | crontab -
ENTRYPOINT ["sh",  "bin/entrypoint.sh"]
CMD ["bundle", "exec", "puma"]
