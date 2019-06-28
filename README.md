# rails-devise-jwt

[Devise](https://github.com/plataformatec/devise) is a flexible and almost a standard authentication solution for Rails, while [JWT](https://jwt.io/)(JSON Web Tokens) is a JSON-based open standard (RFC 7519) for creating access tokens, which is a distributed and faster solution than authentication through databases. 

There is always a need to bring these two beatiful solutions together into rails for better user authentication, which becomes the main reason I created this repo.  Thanks to a lot of the close solutions that gave lots of hints to this repo, for example, this article: [Rails 5 API + JWT setup in minutes (using Devise)](https://medium.com/@mazik.wyry/rails-5-api-jwt-setup-in-minutes-using-devise-71670fd4ed03). However, these solutions have common problems:

* Blurry explanation

* Buggy

* Lots of legacy code that are not usable for current version of frameworks, gems

  

At the same time, we saw couple of other repos doing the same work, but one big issue for these repos is that they are started with **Rails <= 5.0**, which is far different from **Rails 6**, and that contributes to the final reason why we have to "reinvent the wheel again".

As a result, we decided to create this repo which demonstrates how `rails 6`, `devise`, `jwt` fit together like a charm.

### Features

* Rails 6
* Devise
* JWT (JSON Web Tokens)
* Rspec Tests
* [Factory Bot](https://github.com/thoughtbot/factory_bothttps://github.com/thoughtbot/factory_bot) (A library for setting up Ruby objects as test data)
* Docker (A faster docker building solution for rails is provided, that core gems are separated from peripheral gems)
* Puma
* redis, redis-rails
* jwt-blacklist in rails


### Build

Run `bin/build.sh` to build the docker image `rails-devise-jwt`.

### RUN

```bash
docker run -it --rm -v ${PWD}:/usr/src/app -e DEVISE_JWT_SECRET_KEY=XXX -e DATABASE_URL=XXX  rails-devise-jwt rails c
```

### Test

```bash
docker run -it --rm -v ${PWD}:/usr/src/app -e DEVISE_JWT_SECRET_KEY=XXX -e DATABASE_URL=XXX  rails-devise-jwt rspec
```



Following environment varialbes are required in order to run or test:

* `DEVISE_JWT_SECRET_KEY`: You generate this by running `rails secret`
* `DATABASE_URL`: Postgres database url for database connection (You can change this repo to use other databases or make a issue/PR about this)

### Blacklist
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

