FROM ruby:2.7.2-alpine3.12
RUN apk add --no-cache autoconf automake build-base postgresql-dev shared-mime-info postgresql-libs libpq tzdata

WORKDIR /app

COPY Gemfile .
COPY Gemfile.lock .

RUN echo 'gem: --no-document' >> ~/.gemrc && \
    cp ~/.gemrc /etc/gemrc && \
    chmod +r /etc/gemrc && \
    # bundle config set without 'development test' && \
    bundle install -j 4 -r 3

COPY . .

# RUN sed "s/^\([^ ]* *[^ ]* *[^ ]* *[^ ]* *[^ ]* *\)\(.*\)/\1cd \/app;rails runner \"\2\"/" config/cronjobs_rails >> config/cronjobs && \
#     sed 's;\(.*\)$;\1 2>\&1 | tee -a /app/log/cronjobs.log;' config/cronjobs | crontab -

# ENTRYPOINT ["sh",  "bin/entrypoint.sh"]
CMD ["bundle", "exec", "puma"]
