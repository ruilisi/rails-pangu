# rails-pangu

[英文文档 English document](/README.md)

Rails-pangu 是一个基于Design、JWT、Postgres、Redis和Rails技术开发的后台Rails API的简单模板。
	
[Devise](https://github.com/plataformatec/devise)作为一个标准第三方权限认证组件，提供了标准的Rails身份验证解决方案。而 [JWT](https://jwt.io/)（JOSN Web Tokens）是一个基于（RFC 7519）开放标准，直接用JSON创建访问令牌的高效分布式解决方案,而不是通过用数据库进行身份验证。
	
为了更好地进行用户身份验证，我们将这将这两项技术结合到Rails中。与此同时，非常感谢对我创建这份report提供很多参考建议的朋友们，比如在这篇文章中： [Rails 5 API + JWT setup in minutes (using Devise)](https://medium.com/@mazik.wyry/rails-5-api-jwt-setup-in-minutes-using-devise-71670fd4ed03) 。但是，当我们研究以上两种解决方案时，我们发现了一些共同问题：


- 解释不清晰

- Buggy

- 代码冗余、版本兼容性问题

	与此同时，我们看到其他一些开发者也在研究这个问题，但是他们都面临着Rails <= 5.0与Rails 6版本兼容性的问题 。两者之间有很大区别，因此，我们通过融合 `rails 6`, `devise`, `jwt` 这三项技术，解决了这个难题。

<img src="https://res.paiyou.co/pangu.jpg" width="300" align="middle" />

> 盘古是中国神话中万物的创造者。在神话故事，盘古用他巨大的斧头挥动创造了天地，站在天地之间使天地分开。
> 正如盘古一样, `rails-pangu`志在成为你起Rails新项目时的基础性代码库，从而减轻你在做新项目时繁琐的调研和实验工作。

## 开发准备

我们在`rails-pangu`中使用了许多前沿的gems，但这并不意味着构建在这个仓库上的项目是不稳定的，因为我们的团队已经运行了很多基于它的项目。

例如，我们团队开发的  `Computer Game Acceleration` ,  **LINGTI** (https://lingti.io/)

<img src="https://assets.lingti.paiyou.co/ed568fbe.png" width="200" align="middle" />

## 产品特性

#### 🚀 基于Rails 6

与`rails 5`不同，`rails 6`是未来发展的必然趋势。

#### 🚀 Rails API

使用流行前端的js库如`react`，`vuejs`，替换原来的`rails view`

#### 🚀 [Devise](https://github.com/plataformatec/devise)

来自Devise官方文档：

> Devise是基于Warden的Rails身份验证解决方案。它具有以下特点：
>
> - 基于Rack;
> - 是一个基于Rails引擎的完整MVC解决方案;
> - 允许您同时运行多个模型;
> - 功能模块化，只需要调用所需要的模块。

由此可见，`devise`提供了一套完整的符合行业标准且方便使用的身份验证方式。

#### 🚀 JWT

JSON Web Tokens，是目前最流行的跨域认证解决方案。

#### 🚀 [devise-jwt](https://github.com/waiting-for-dev/devise-jwt)

实现了将`devise`和`jwt`技术融合,虽然也有其他开发者通过其它方式也实现了两者的融合运用，但都效果欠佳。

我们在 [app/models/jwt_blacklist.rb](https://github.com/paiyou-network/rails-pangu/blob/master/app/models/jwt_blacklist.rb) 里面通过使用redis来实现了 devise-jwt的 `blacklist strategy`。

#### 🚀 Postgres
使用postgres作为默认数据库。当一个Web服务器的流量变得很大时，sqlite3显然无法满足我们的需求。

#### 🚀 Rspec
Ruby行为驱动测试框架，让TDD高效有趣。

#### 🚀 [RuboCop](https://docs.rubocop.org)
Ruby代码静态分析和格式工具，基于社区Ruby样式准侧 

#### 🚀 [Factory Bot](https://github.com/thoughtbot/factory_bothttps://github.com/thoughtbot/factory_bot)
将Ruby对象设置为测试用例。

#### 🚀 Docker

标准的轻量级操作系统虚拟化解决方案，在全球得到了广泛应用。它提供了dockerfile文件和couple脚本来生成docker镜像。

虽然有很多用于rails相关项目的`Dockerfile`，但我们通过一个更简单的方法来进一步简化了启动docker的构建过程。当一个项目迭代更新时，docker可以同时实现数百甚至数千种不同版本的gems，大多数docker镜像在创建时会因为捆绑不必要的gems浪费系统资源，例如`rails`，`pg`等等。

因此，下面演示了我们如何清除镜像构建过程的重复部分：

```shell
COPY Gemfile.core .
RUN echo 'gem: --no-document' >> ~/.gemrc && \
    cp ~/.gemrc /etc/gemrc && \
    chmod +r /etc/gemrc && \
    bundle install --gemfile Gemfile.core -j16 --binstubs=$BUNDLE_PATH/bin

COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install --gemfile Gemfile -j16 --binstubs=$BUNDLE_PATH/bin
```

通过以上几行代码，可以将常见的最常用的gems 进行打包，然后将需要使用的库打包。不过，这个过程会生成额外的Docker镜像层，使镜像变大（预计几百KB）。但这样做是有意义的，因为程序运行时间比磁盘空间要有限得多。

#### 🚀 Docker Compose

通过一个`docker compose.yml`文件，可以实现postgres和web服务器的快速构建。

#### 🚀 [Puma](https://github.com/puma/puma)

Puma是一个简单、快速、线程化、高度并发的HTTP1.1服务器，用于Ruby/Rack应用的开发。

#### 🚀 Redis

几乎所有的Web项目都使用`redis`作为存储系统，因为它快速、高效、简洁。



## 开始运行

#### Build

运行`bin/build.sh`来构建docker镜像`rails-devise-jw`。

#### Run

创建镜像后，运行：`docker-compose up -d`
然后，用`docker compose exec server rails db:create`初始化数据库。

#### Test

```ruby
docker-compose exec server rspec
```

运行或测试需要以下环境变量（选中`docker-cmpose.yml`）:

- `DEVISE_JWT_SECRET_KEY`:运行`Rails Secret`生成密钥。
- `DATABASE_URL`: 连接Postgres数据库的URL。
- `REDIS_URL`: 连接Redis数据库的URL。



## 添加脚本到 cron job

你可以添加cron job 在 `bin/gen_cronjobs.rb`, 样例如下.

```ruby
puts [
  "59 * * * * ruby script",
  "*/10 * * * * ruby script"
].map { |job|
  *schedule, cmd = job.split(' ')
  "#{schedule.join(' ')} cd /usr/src/app; rails runner \"Util.run_once('#{cmd}')\""
}.join("\n")
```

如果你想运行 bash 脚本,你可以把 `cd /usr/src/app; rails runner \"Util.run_once('#{cmd}')\"` 替换为你自定义的命令.



## 角色创建

除了我们提供的默认角色之外，我们还允许developer创建他们的[自定义角色](https://github.com/paiyou-network/rails-pangu/wiki/create-a-role)。

## Blacklist

####默认redis黑名单

由于redis的访问内存的性能极高，redis是用来实现`blacklist`的一个好的选择。在`jwt_blacklist`中，我们用redis实现了黑名单。通过将`redis`的过期时间设置为与`jwt token`的过期时间相同，可以在令牌过期时自动从redis中删除此令牌。

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



#### 自定义黑名单

你也可以通过自己的策略实现黑名单。你只需要重写两个方法：`jwt-revoked？`以及`jwt-blacklist.rb`中的`revoke-jwt`，这两个方法都接受jwt负载和`user`记录作为参数。

```ruby
  def self.jwt_revoked?(payload, user)
    # Does something to check whether the JWT token is revoked for given user
  end

  def self.revoke_jwt(payload, user)
    # Does something to revoke the JWT token for given user
  end
```



#### 请求调用

您可以在`device.rb`中配置`dispatch`请求。当配置它时，您需要说明哪些请求将为以前经过身份验证的用户分派令牌（通常通过其他一些Warden策略，例如需要用户名和电子邮件参数的策略）。配置它时，需要将请求路径添加到`dispath_requests`。

```ruby
  jwt.dispatch_requests = [['POST', %r{^users/sign_in$}]]

```



#### 取消请求

您可以在`device.rb`中配置`dispatch`请求。配置时，先将请求路径添加到撤销请求中，并说明哪些请求需要取消传入JWT令牌。

```ruby
  jwt.revocation_requests = [['DELETE', %r{^users/sign_out$}]]
```



#### Jwt payload

`user`记录还可以实现`jwt_payload`方法，这使它有机会向JWT负载添加一些内容。

```ruby
  def jwt_payloads
    # { 'foo' => 'bar' }
  end
```



#### Jwt dispatch

在`user`记录上添加一个hook方法`on_jwt_dispatch`。它在用户调用令牌时执行，并将令牌和有效负载作为参数。这个方法也会在你调用`dispatch_requests`访问路由时被调用。

```ruby
  def on_jwt_dispatch(token, payload)
    # do_something(token, payload)
  end
```
