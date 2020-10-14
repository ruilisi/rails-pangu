[![CircleCI](https://circleci.com/gh/ruilisi/rails-pangu.svg?style=svg)](https://circleci.com/gh/ruilisi/rails-pangu)
[![All Contributors](https://img.shields.io/badge/all_contributors-6-orange.svg?style=flat-square)](#contributors)

# Rails-pangu
[中文文档 Chinese document](/README.CN.md)

`Rails-pangu` is a **Rails 6(API Only)** boilerplate which follows cutting-edge solutions already adopted by the industry, notablly, [Devise](https://github.com/plataformatec/devise), [JWT(JSON Web Tokens)](https://jwt.io/), Postgres, Redis, Docker, Rspec, RuboCop, [CircleCI](https://circleci.com/). It is a solid production-ready starting point for your new backend projects.

[Devise](https://github.com/plataformatec/devise) is a flexible and almost a standard authentication solution for Rails, while [JWT](https://jwt.io/)(JSON Web Tokens) is a JSON-based open standard (RFC 7519) for creating access tokens, which is a distributed and faster solution than authentication through databases.

There is always a strong need to bring these two beautiful solutions together into rails for better user authentication, however, there's no single satisfying article or project which demonstrates how to incorporate both with Rails 6(API Only), which becomes the main reason for the birth of `Rails-pangu`.

<img src="https://res.paiyou.co/pangu.jpg" width="300" style="margin-bottom: 6px;" align="center" />

> Pangu is the first living being and the creator of all in some versions of Chinese mythology[<sup>1</sup>](#refer-pangu).
> Just like pangu, `Rails-pangu` aims to be a starter kit of your next rails project which eliminates tricky but repeated work.

## Getting Started
```bash
~ $ git clone https://github.com/ruilisi/rails-pangu
~ $ cd rails-pangu
~ $ bundle install
~ $ rails db:create db:migrate db:seed
~ $ rspec
```

Try [Run & Test](#run-and-test) to get hands-on experience with `rails-pangu`.

## Features

#### 🚀 Rails 6 (API only)

As explained above, `rails 6` is the future and is far different from `rails 5`.

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

We implmented a devise-jwt denylist policy leveraging the power of `redis` in [app/models/jwt_denylist.rb](https://github.com/ruilisi/rails-devise-jwt/blob/master/app/models/jwt_denylist.rb).

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
`Dockerfile` with customized features is added to this project:
* Original gem source `https://rubygems.org` is mirrored to `https://gems.ruby-china.com` which both accelerates bundling speed for developers in China 
and acts as an example of using Gem mirror.

#### 🚀 Docker Compose
`docker-compose.yml` with containers `web`, `postgres`, `redis` is added.
> `rspec` and some other commands are not avaiable in `web` container since the docker image is bundled with only gems for production mode through `bundle config set without 'development test'`.
```bash
~ $ docker-compose up -d
~ $ docker-compose exec web rails db:create db:migrate db:seed
```
Then you can run steps in [Run & Test](#run-and-test) as port `3000` is mapped and exposed.

#### 🚀 [Puma](https://github.com/puma/puma)
Puma is a simple, fast, threaded, and highly concurrent HTTP 1.1 server for Ruby/Rack applications in development and production.

#### 🚀 Redis
Is there any web project isn't using `redis` as a faster and sometimes easier way of storing data? Well, if there isn't,  just replace it!

## CORS
`config/cors.rb` is changed in the way that any origin is allowed, and `Authorization` is allowed in header of any kind of request.

## Cronjobs
We provide several ways with convenient defaults for adding cronjobs into the running containers as cronjobs are a big part for a project.


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

## Denylist

#### Default denylist with redis

Redis is a good option for `denylist` that will allow fast in memory access to the list. In `jwt_denylist` record, we implement denylist with redis. By setting `redis` expiration time to be the same as `jwt token` expiration time, this token can be automatically deleted from redis when the token expires.

```ruby
  def self.jwt_revoked?(payload, user)
    # Check if in the denylist
    $redis.get("user_denylist:#{user.id}:#{payload['jti']}").present?
  end

  def self.revoke_jwt(payload, user)
    # REVOKE JWT
    expiration = payload['exp'] - payload['iat']
    $redis.setex("user_denylist:#{user.id}:#{payload['jti']}", expiration, payload['jti'])
  end
```

#### Custom denylist

You can also implement denylist by your own strategies. You just need to rewrite two methods: `jwt_revoked?` and `revoke_jwt` in `jwt_denylist.rb`, both of them accepting as parameters the JWT payload and the `user` record, in this order.

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

<div id="run-and-test"></div>

## Run & Test

**Requirements**
* Rails server running with `rails s`
* `httpie` installed

```bash
~ $ http -b localhost:3000/ping
pong

~ $ http -b post localhost:3000/users user:='{"email":"user@test.com","password":"Test1aBc"}'
{
    "created_at": "2020-10-10T05:43:20.349Z",
    "email": "user@test.com",
    "id": 1,
    "updated_at": "2020-10-10T05:43:20.349Z"
}

~ $ http post localhost:3000/users/sign_in user:='{"email":"user@test.com","password":"Test1aBc"}'
HTTP/1.1 200 OK
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNjAyMzE3ODYxLCJleHAiOjE2MDI0MDQyNjEsImp0aSI6IjNkOGY4ZThkLTY2YjUtNGE5Ny05YzkzLTUxZmFmMGQyMTM1YSJ9.Q-HWFNtLtfNO2iZsTRBfmlJlBBxHWTwrSlTjBaS6GNI
Cache-Control: max-age=0, private, must-revalidate
Content-Type: application/json; charset=utf-8
ETag: W/"df30d418ad05c15dbfdc6e34ef53f723"
Referrer-Policy: strict-origin-when-cross-origin
Transfer-Encoding: chunked
X-Content-Type-Options: nosniff
X-Download-Options: noopen
X-Frame-Options: SAMEORIGIN
X-Permitted-Cross-Domain-Policies: none
X-Request-Id: 957a1c92-c5a8-4607-81df-6ca70ba9b846
X-Runtime: 0.193702
X-XSS-Protection: 1; mode=block

{
    "created_at": "2020-10-10T05:43:20.349Z",
    "email": "user@test.com",
    "id": 1,
    "updated_at": "2020-10-10T05:43:20.349Z"
}
```

`GET auth_ping` with the bearer(`eyJhbGciOiJIUzI1NiJ9...`) returned by `POST users/sign_in`:
```bash
~ $ http -b localhost:3000/auth_ping "Authorization:Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNjAyMzE3ODYxLCJleHAiOjE2MDI0MDQyNjEsImp0aSI6IjNkOGY4ZThkLTY2YjUtNGE5Ny05YzkzLTUxZmFmMGQyMTM1YSJ9.Q-HWFNtLtfNO2iZsTRBfmlJlBBxHWTwrSlTjBaS6GNI"
pong

```

`GET` `auth_ping` without bearer will result `401 Unauthorized`:
```bash
~ $ http localhost:3000/auth_ping                                                                                                                                                              [ruby-2.7.2]
HTTP/1.1 401 Unauthorized
Cache-Control: no-cache
Content-Type: */*; charset=utf-8
Transfer-Encoding: chunked
X-Request-Id: 8c21f5f2-f385-4b0b-b1f6-478ef06de256
X-Runtime: 0.003266

You need to sign in or sign up before continuing.

```


## Projects using rails-pangu

- **[LINGTI](https://lingti666.com)**  (https://lingti666.com/): Lingti is a game booster which brings faster, smoother gaming experience with clients of PC/Mac/Android/iOS/Router/Router Plugin implemented.
- **[eSheep](https://esheeps.com)**  (https://esheeps.com/): Network booster which helps global users access better entertainment content from Asia.


[<img src="https://esheeps.com/imgs/logo.png" height="100" align="middle" />](https://esheeps.com)
[<img src="https://lingti666.com/imgs/lingti-logo.png" height="50" align="middle" />](https://lingti666.com)

## License

Code and documentation copyright 2019 the [Rails-pangu Authors](https://github.com/ruilisi/rails-pangu/graphs/contributors) and [Ruilisi Technology](https://ruilisi.co/) Code released under the [MIT License](https://github.com/ruilisi/rails-pangu/blob/master/LICENSE). 

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
  </tr>
</table>

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!

## Reference
<div id="refer-pangu"></div>

- [1] [Wiki of Pangu](https://en.wikipedia.org/wiki/Pangu)
