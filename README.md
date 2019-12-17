[![CircleCI](https://circleci.com/gh/ruilisi/rails-pangu.svg?style=svg)](https://circleci.com/gh/ruilisi/rails-pangu)
[![All Contributors](https://img.shields.io/badge/all_contributors-6-orange.svg?style=flat-square)](#contributors)

# Rails-pangu
[中文文档 Chinese document](/README.CN.md)

`Rails-pangu` is a **Rails 6(API Only)** boilerplate which follows cutting-edge solutions already adopted by the industry, notablly, [Devise](https://github.com/plataformatec/devise), [JWT(JSON Web Tokens)](https://jwt.io/), Postgres, Redis, Docker, Rspec, RuboCop, [CircleCI](https://circleci.com/). It is a solid production-ready starting point for your new backend projects.

**Mixing all these solutions and letting them work perfectly is not easy. Here is an example**:

[Devise](https://github.com/plataformatec/devise) is a flexible and almost a standard authentication solution for Rails, while [JWT](https://jwt.io/)(JSON Web Tokens) is a JSON-based open standard (RFC 7519) for creating access tokens, which is a distributed and faster solution than authentication through databases.

There is always a strong need to bring these two beautiful solutions together into rails for better user authentication, however, there's no single satisfying article or project which demonstrates how to incorporate both with Rails 6(API Only), which becomes the main reason for the birth of `Rails-pangu`.

Thanks to lots of the close solutions that gave hints to this `Rails-pangu`, for example, this article: [Rails 5 API + JWT setup in minutes (using Devise)](https://medium.com/@mazik.wyry/rails-5-api-jwt-setup-in-minutes-using-devise-71670fd4ed03). However, these solutions have common problems:

- Blurry explanation

- Buggy

- Lots of legacy code that are not usable for current version of frameworks, gems

At the same time, we saw couple of other repos doing the same work, but one big issue for these repos is that they are started with **Rails <= 5.0**, which is far different from **Rails 6**, and that contributes to the final decision to "reinvent the wheel again".

<img src="https://res.paiyou.co/pangu.jpg" width="300" align="middle" />

> Pangu is the creator of all in Chinese mythology. In the stories, Pangu created the Earth and the Sky with a swing of his giant axe and kept them seperated by standing between them.
> Just like pangu, `Rails-pangu` aims at being a foundational code base which eliminates those tedious research and experimental work for your new Rails projects.

## Features

#### 🚀 Rails 6

As explained above, `rails 6` is the future and is far different from `rails 5`.

#### 🚀 Rails API only

It is common to use frontend js libraries like `react`, `vuejs` to replace `rails view` in modern web development

#### 🚀 [Devise](https://github.com/plataformatec/devise)

Quoted from it's homepage:

> Devise is a flexible authentication solution for Rails based on Warden. It:
>
> - Is Rack based;
> - Is a complete MVC solution based on Rails engines;
> - Allows you to have multiple models signed in at the same time;
> - Is based on a modularity concept: use only what you really need.

To our best of knowledge, `devise` provides a full, industry-standard, easy-to-ingrate way of all kinds of authentication. Damn, it's awesome!

#### 🚀 JWT

JSON Web Tokens

#### 🚀 [devise-jwt](https://github.com/waiting-for-dev/devise-jwt)

While there are lots of solutions which hook `devise` and `jwt` together, this repo is better implemented from our point of view.

We implmented a devise-jwt blacklist policy leveraging the power of `redis` in [app/models/jwt_blacklist.rb](https://github.com/ruilisi/rails-devise-jwt/blob/master/app/models/jwt_blacklist.rb).

#### 🚀 Postgres
We use postgres as default database store cause sqlite3 will be replaced sooner or later when the traffic of one web server becomes lager enough

#### 🚀 Rspec
Behaviour Driven Development for Ruby. Making TDD Productive and Fun.

#### 🚀 RuboCop
A Ruby static code analyzer and formatter, based on the community Ruby style guide. https://docs.rubocop.org

#### 🚀 [CircleCI](https://circleci.com/)
CircleCI is the leading continuous integration and delivery platform for teams looking to shorten the distance between idea and delivery
In this project, we leverage CircleCI to test `Rails-pangu`'s code base with both `rspec` and `RuboCop`

#### 🚀 [Factory Bot](https://github.com/thoughtbot/factory_bothttps://github.com/thoughtbot/factory_bot)
A library for setting up Ruby objects as test data.

#### 🚀 Docker

Docker is a standard containerize solution which is almost used in every team worldwide. As a result, a `Dockerfile` and related scripts are provided to help generate a docker image for this project.

The provided docker building solution contains the following optimizations: 

* Docker building acceleration

  When a project grows, hundreds or even thousands of different versions of different gems will be tried or used. Even a small change in `Gemfile` causes re-bundling for every `Gem` while building a `Ruby` based docker image, that most of the docker image building time is wasted for bundling a large number of stable gems, such as `rails`, `pg`... To solve this issue, we utilized a trick which accelerates the docker building process by bundling two rounds for `Gemfile` files, and generates two layers of docker image: 

  * Build the first layer for `Gemfile.core`, which is for stable or core `Gem`s, such as `rails`, `pg`.
  * Build the second layer for `Gemfile`,  which is for mutable or non-core `Gem`s, for example, `Gem`s wrote or forted by yourself.

  Though, this process generates extra one layer of docker image which makes the image lager a little bit(hundreds of `KB`s). It worths that way cause **time is much more limited than disk space**

  The following lines of `Dockerfile` demonstrates this docker building process: 

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

* Bundling `Gem`s acceleration (For developers in China only)

  By default, we mirror gem source `https://rubygems.org` to `https://gems.ruby-china.com`, which boosts the bundling speed largely for developers in China. 

  

#### 🚀 Docker Compose

A `docker-compose.yml` is attached to help stick postgres and web server together quickly.

#### 🚀 [Puma](https://github.com/puma/puma)

Puma is a simple, fast, threaded, and highly concurrent HTTP 1.1 server for Ruby/Rack applications in development and production.

#### 🚀 Redis

Is there any web project isn't using `redis` as a faster and sometimes easier way of storing data? Well, if there isn't,  just replace it!


## Build, Run, Test

#### Build

Run `bin/build.sh` to build the docker image `rails-devise-jwt`.



#### Run

After built the image, run: `docker-compose up -d`

Then, initialize the database with `docker-compose exec server rails db:create`



#### Test

```bash
docker-compose exec server rspec
```



The following environment varialbes are required in order to run or test (check `docker-cmpose.yml`):

- `DEVISE_JWT_SECRET_KEY`: You generate this by running `rails secret`
- `DATABASE_URL`: Postgres database url for database connection
- `REDIS_URL`: Redis database url for database connection



## CORS

We allow CORS and expose the Authorization header by default. If you want to disable it, you can comment out the contents of the `config/cors.rb` file.



## Add script to cron job

You can add cron job in `bin/gen_cronjobs.rb`, an example is as follows.

```ruby
puts [
  "59 * * * * ruby script",
  "*/10 * * * * ruby script"
].map { |job|
  *schedule, cmd = job.split(' ')
  "#{schedule.join(' ')} cd /usr/src/app; rails runner \"Util.run_once('#{cmd}')\""
}.join("\n")
```

If you want to run bash script, you can replace `cd /usr/src/app; rails runner \"Util.run_once('#{cmd}')\"` to your custom cmd.



## Create a role

In addition to the default role we provide, we also allow developers to create their custom role. There is a document about how to [create a new role](https://github.com/ruilisi/rails-pangu/wiki/Create-a-role)

## Blacklist

#### Default blacklist with redis

Redis is a good option for `blacklist` that will allow fast in memory access to the list. In `jwt_blacklist` record, we implement blacklist with redis. By setting `redis` expiration time to be the same as `jwt token` expiration time, this token can be automatically deleted from redis when the token expires.

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


## Projects using rails-pangu

* **[LINGTI](https://lingti.io)**  (https://lingti.io/): Game booster which helps you get better, faster, smoother performance from your PC. It is now popular among game players playing [MTGA](https://magic.wizards.com/en/mtgarena), [MTGO](https://magic.wizards.com/en/mtgo), [LOL](https://lol.qq.com/main.shtml), [World of Warcraft](https://worldofwarcraft.com/), [PUBG](https://www.pubg.com/), [Dota2](https://www.dota2.com.cn/index.htm), [CSGO](https://www.csgo.com.cn/index.html), etc.
* **[eSheep](https://esheep.io)**  (https://esheep.io/): Network booster which helps global users access better entertainment content from China.

[<img src="https://assets.lingti.paiyou.co/ed568fbe.png" width="150" align="middle" />](https://lingti.io) [<img src="https://res.paiyou.co/44920709.png" width="200" align="middle" />](https://lingti.io)

## License

Code and documentation copyright 2019 the [Rails-pangu Authors](https://github.com/ruilisi/rails-pangu/graphs/contributors) and [Paiyou Network](https://paiyou.co/) Code released under the [MIT License](https://github.com/ruilisi/rails-pangu/blob/master/LICENSE). 

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore -->
<table>
  <tr>
    <td align="center"><a href="https://paiyou.co/"><img src="https://avatars2.githubusercontent.com/u/3121413?v=4" width="100px;" alt="hophacker"/><br /><sub><b>hophacker</b></sub></a><br /><a href="https://github.com/ruilisi/rails-pangu/commits?author=hophacker" title="Code">💻</a> <a href="https://github.com/ruilisi/rails-pangu/commits?author=hophacker" title="Documentation">📖</a> <a href="#infra-hophacker" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
    <td align="center"><a href="https://github.com/zhcalvin"><img src="https://avatars3.githubusercontent.com/u/5792099?v=4" width="100px;" alt="Jiawei Li"/><br /><sub><b>Jiawei Li</b></sub></a><br /><a href="https://github.com/ruilisi/rails-pangu/commits?author=zhcalvin" title="Code">💻</a> <a href="https://github.com/ruilisi/rails-pangu/commits?author=zhcalvin" title="Documentation">📖</a></td>
    <td align="center"><a href="https://github.com/zyc9012"><img src="https://avatars1.githubusercontent.com/u/3034310?v=4" width="100px;" alt="tato"/><br /><sub><b>tato</b></sub></a><br /><a href="https://github.com/ruilisi/rails-pangu/commits?author=zyc9012" title="Code">💻</a> <a href="https://github.com/ruilisi/rails-pangu/commits?author=zyc9012" title="Documentation">📖</a></td>
    <td align="center"><a href="https://github.com/caibiwsq"><img src="https://avatars0.githubusercontent.com/u/37767017?v=4" width="100px;" alt="caibiwsq"/><br /><sub><b>caibiwsq</b></sub></a><br /><a href="https://github.com/ruilisi/rails-pangu/commits?author=caibiwsq" title="Code">💻</a> <a href="https://github.com/ruilisi/rails-pangu/commits?author=caibiwsq" title="Documentation">📖</a></td>
    <td align="center"><a href="http://blog.cloud-mes.com/"><img src="https://avatars3.githubusercontent.com/u/1131536?v=4" width="100px;" alt="Eric Guo"/><br /><sub><b>Eric Guo</b></sub></a><br /><a href="https://github.com/ruilisi/rails-pangu/commits?author=Eric-Guo" title="Code">💻</a> <a href="https://github.com/ruilisi/rails-pangu/commits?author=Eric-Guo" title="Documentation">📖</a></td>
    <td align="center"><a href="https://github.com/alen9968"><img src="https://avatars2.githubusercontent.com/u/38801833?v=4" width="100px;" alt="张学财"/><br /><sub><b>张学财</b></sub></a><br /><a href="https://github.com/ruilisi/rails-pangu/commits?author=alen9968" title="Code">💻</a> <a href="https://github.com/ruilisi/rails-pangu/commits?author=alen9968" title="Documentation">📖</a></td>
    <td align="center"><a href="https://github.com/czj-Crazy"><img src="https://avatars1.githubusercontent.com/u/54089927?v=4" width="100px;" alt="czj-Crazy"/><br /><sub><b>czj-Crazy</b></sub></a><br /><a href="https://github.com/ruilisi/rails-pangu/commits?author=czj-Crazy" title="Documentation">📖</a></td>
  </tr>
</table>

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
