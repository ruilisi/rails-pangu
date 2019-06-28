# rails-devise-jwt

[Devise](https://github.com/plataformatec/devise) is a flexible and almost a standard authentication solution for Rails, while [JWT](https://jwt.io/)(JSON Web Tokens) is a JSON-based open standard (RFC 7519) for creating access tokens, which is a distributed and faster solution than authentication through databases. 

There is always a need to bring these two beatiful solutions together into rails for better user authentication, which becomes the main reason I created this repo.  Thanks to a lot of the close solutions that gave lots of hints to this repo, for example, this article: [Rails 5 API + JWT setup in minutes (using Devise)](https://medium.com/@mazik.wyry/rails-5-api-jwt-setup-in-minutes-using-devise-71670fd4ed03). However, these solutions have common problems:

* Blurry explanation

* Buggy

* Lots of legacy code that are not usable for current version of frameworks, gems

  

At the same time, we saw couple of other repos doing the same work, but one big issue for these repos is that they are started with **Rails <= 5.0**, which is far different from **Rails 6**, and that contributes to the final reason why we have to "reinvent the wheel again".

As a result, we decided to create this repo which demonstrates how `rails 6`, `devise`, `jwt` fit together like a charm.

## Production Ready

We are using lots of cutting edge gems in `rails-devise-jwt`, but it does not mean projects built upon this repo will be fragile, cause our team has run lots of projects based upon it.

For example, the backend of a  `Computer Game Acceleration` product by our team,  **LINGTI**  (https://lingti.io/)

<img src="https://assets.lingti.paiyou.co/ed568fbe.png" width="200" align="middle" />

## Features

#### Rails 6

As explained above, `rails 6` is the future and is far different from `rails 5`. Rails API only

It is common to use frontend js libraries like `react`, `vuejs` to replace `rails view` in mordern web deveopment

#### Devise

#### devise-jwt [Repo](https://github.com/waiting-for-dev/devise-jwt)

While there are lots of solutions which hook `devise` and `jwt` together, this repo is better implemented from our point of view.

We implmented a devise-jwt blacklist policy leveraging the power of `redis` in [app/models/jwt_blacklist.rb](https://github.com/paiyou-network/rails-devise-jwt/blob/master/app/models/jwt_blacklist.rb).

#### JWT

JSON Web Tokens

#### Postgres

We use postgres as default database store cause sqlite3 will be replaced sooner or later when the traffic of one web server becomes lager enough

#### Rspec

#### Factory Bot  [Doc](https://github.com/thoughtbot/factory_bothttps://github.com/thoughtbot/factory_bot)

A library for setting up Ruby objects as test data.

#### Docker

Standard containerize solution which is almost used in every team worldwide. As a result, a `Dockerfile` and couple scripts are provided to help generate a docker image of this project.

While there are a vast number of `Dockerfile`s for rails related projects, we implemented a easy method that can boost the docker building process.  When a project grows, hundreds or even thousands of different versions of different gems will be tried, that most of the docker image building time is wasted for bundling a large amount of stable gems, such as `rails`, `pg`...

Thus, the following lines demonstrates how we eliminate the duplicated parts of the image building process:

```dockerfile
COPY Gemfile.core .
RUN echo 'gem: --no-document' >> ~/.gemrc && \
    cp ~/.gemrc /etc/gemrc && \
    chmod +r /etc/gemrc && \
    bundle install --gemfile Gemfile.core -j16 --binstubs=$BUNDLE_PATH/bin

COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install --gemfile Gemfile -j16 --binstubs=$BUNDLE_PATH/bin
```



Through the above lines, common and stablly used gems will be bundled first, then those transitory gems or gems under trying will be bundled. Though, this process generates extra docker image layers which makes the image lager a little bit(didn't caculate, but guess it's like hundreds of `KB`s). It worths that way cause **time is much more limited than disk space**

#### Docker Compose

A `docker-compose.yml` is attached to help sticking postgres and web server together quickly, and make this repo **production ready**.

#### Puma  [Repo](https://github.com/puma/puma)

Puma is a simple, fast, threaded, and highly concurrent HTTP 1.1 server for Ruby/Rack applications in development and production.

#### Redis

Is there any web project isn't using `redis` as a faster and sometimes easier way of storing data? Well, if there isn't,  just replace it!



## Build

Run `bin/build.sh` to build the docker image `rails-devise-jwt`.



## RUN

```bash
docker run -it --rm -v ${PWD}:/usr/src/app -e DEVISE_JWT_SECRET_KEY=XXX -e DATABASE_URL=XXX  rails-devise-jwt rails c
```



## Test

```bash
docker run -it --rm -v ${PWD}:/usr/src/app -e DEVISE_JWT_SECRET_KEY=XXX -e DATABASE_URL=XXX  rails-devise-jwt rspec
```



Following environment varialbes are required in order to run or test:

* `DEVISE_JWT_SECRET_KEY`: You generate this by running `rails secret`
* `DATABASE_URL`: Postgres database url for database connection (You can change this repo to use other databases or make a issue/PR about this)



## Blacklist

#### Defualt blacklist with redis
In `jwt_blacklist` record, we implement blacklist with redis. When token has expired, it will auto delete this token in redis.

```ruby
  def self.jwt_revoked?(payload, user)
    # Check if in the blacklist
    $redis.get("user_blacklist:#{user.id}:#{payload['jti']}").present?
  end

  def self.revoke_jwt(payload, user)
    # REVOKE JWT
    expiration = payload['exp'] - payload['iat']
    $redis.setex("user_blacklist:#{user.id}:#{payload['jti']}", expiration, payload['jti'])
  end
```
#### Custom blacklist
You can also implement blacklist by your own strategies. You just need to rewrite two methods: `jwt_revoked?` and `revoke_jwt` in `jwt_blacklist.rb`, both of them accepting as parameters the JWT payload and the `user` record, in this order.

```ruby
  def self.jwt_revoked?(payload, user)
    # Does something to check whether the JWT token is revoked for given user
  end

  def self.revoke_jwt(payload, user)
    # Does something to revoke the JWT token for given user
  end
```
#### Dispatch requests
You can config `dispatch_requests` in `devise.rb`. When config it, you need to tell which requests will dispatch tokens for the user that has been previously authenticated (usually through some other warden strategy, such as one requiring username and email parameters). To configure it, you can add the the request path to dispath_requests. 

```ruby
  jwt.dispatch_requests = [['POST', %r{^users/sign_in$}]]

```
#### Revocation requests
You can config `dispatch_requests` in `devise.rb`. When config it, you need to tell which requests will revoke incoming JWT tokens, and you can add the the request path to revocation_requests

```ruby
  jwt.revocation_requests = [['DELETE', %r{^users/sign_out$}]]
```
#### Jwt payload
`user` records may also implement a jwt_payload method, which gives it a chance to add something to the JWT payload. 

```ruby
  def jwt_payloads
    # { 'foo' => 'bar' }
  end
```

#### Jwt dispatch
You can add a hook method `on_jwt_dispatch` on the `user` record. It will execute when a token dispatched for that user instance, and it takes token and payload as parameters. And this method will call when 
you access the routes which in dispatch_requests

```ruby
  def on_jwt_dispatch(token, payload)
    # do_something(token, payload)
  end
```

