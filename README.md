# rails-devise-jwt

[Devise](https://github.com/plataformatec/devise) is a flexible and almost a standard authentication solution for Rails, while [JWT](https://jwt.io/)(JSON Web Tokens) is a JSON-based open standard (RFC 7519) for creating access tokens, which is a distributed and faster solution than authentication through databases. 

There is always a need to bring these two beatiful solutions together into rails for better user authentication, which becomes the main reason I created this repo.  Thanks to a lot of the close solutions that gave lots of hints to this repo, for example, this article: [Rails 5 API + JWT setup in minutes (using Devise)](https://medium.com/@mazik.wyry/rails-5-api-jwt-setup-in-minutes-using-devise-71670fd4ed03). However, these articles have common issues:

* Buggy

* Legacy code

* Not showing code base

  And that's another reason I need to create a repo which demonstrates how `rails`, `devise`, `jwt` could fit together like a charm.



### Features

* Devise
* JWT
* Rspec Tests
* [Factory Bot](https://github.com/thoughtbot/factory_bothttps://github.com/thoughtbot/factory_bot) (A library for setting up Ruby objects as test data)
* Rails 6
* Docker (A faster docker building solution for rails is provided, that core gems are separated from peripheral gems)
* Puma to start server
* redis, redis-rails



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
