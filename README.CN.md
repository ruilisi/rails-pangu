[![CircleCI](https://circleci.com/gh/ruilisi/rails-pangu.svg?style=svg)](https://circleci.com/gh/ruilisi/rails-pangu)
[![All Contributors](https://img.shields.io/badge/all_contributors-5-orange.svg?style=flat-square)](#contributors)

# Rails-pangu

[英文文档 English document](/README.md)

`Rails-pangu` 是一个基于**Rails 6(API Only)**框架搭建的一站式服务开发的技术解决方案，它整合了 [Devise](https://github.com/plataformatec/devise), [JWT(JSON Web Tokens)](https://jwt.io/), Postgres, Redis, Docker, Rspec, RuboCop, [CircleCI](https://circleci.com/) 等多项业界尖端技术，它是后端项目开发的起点，可作为开发者强有力的生产工具。
	
**整合这些前沿技术并让他们完全兼容运行并非易事，案例如下**：
[Devise](https://github.com/plataformatec/devise)作为一个标准第三方权限认证组件，提供了标准的Rails身份验证解决方案，而 [JWT](https://jwt.io/)（JOSN Web Tokens）是一个基于（RFC 7519）开放标准，直接用JSON创建访问令牌的高效分布式解决方案，而不是通过用数据库进行身份验证。在实际的开发需求中，我们迫切希望通过融合以上这两种技术来解决用户身份验证的问题。但是，当我们研究以上两种解决方案时，我们发现了一些共同问题：

- 文档解释不清晰
- 存在多处bug
- 代码冗余、存在版本兼容性问题

与此同时，我们看到其他一些开发者也在研究这个问题，但是他们都面临着**Rails <= 5.0**与**Rails 6**版本兼容性的问题 。两者之间有很大区别，因此，通过梳理 `rails 6`, `devise`, `jwt` 这三项技术，我们顺利解决了这个难题，实现了三者在Rails中的完美融合。与此同时，非常感谢为此项目提供很多参考建议的朋友们，比如这篇文章： [Rails 5 API + JWT setup in minutes (using Devise)](https://medium.com/@mazik.wyry/rails-5-api-jwt-setup-in-minutes-using-devise-71670fd4ed03) 。

<img src="https://res.paiyou.co/pangu.jpg" width="300" align="middle" />

> 盘古是中国神话中万物的创造者。在神话故事中，盘古挥舞着巨大的斧头开辟了天地，矗立在天地之间使其分隔开来。
> 正如盘古一样, `Rails-pangu`志在成为你起用Rails新项目时的基础性代码库，从而减轻你在做新项目时繁琐的调研和实验工作。

## 开始
```bash
~ $ git clone https://github.com/ruilisi/rails-pangu
~ $ cd rails-pangu
~ $ bundle install
~ $ rails db:create db:migrate db:seed
~ $ rails s
```

安装`httpie`然后运行:
```bash
~ $ http post localhost:3000/users user:='{"email":"user@test.com","password":"Test1aBc"}'
HTTP/1.1 200 OK
Cache-Control: max-age=0, private, must-revalidate
Content-Type: application/json; charset=utf-8
ETag: W/"df30d418ad05c15dbfdc6e34ef53f723"
Referrer-Policy: strict-origin-when-cross-origin
Transfer-Encoding: chunked
X-Content-Type-Options: nosniff
X-Download-Options: noopen
X-Frame-Options: SAMEORIGIN
X-Permitted-Cross-Domain-Policies: none
X-Request-Id: 689485eb-5e33-4ba2-afe8-ca7214088eda
X-Runtime: 0.216293
X-XSS-Protection: 1; mode=block

{
    "created_at": "2020-10-10T05:43:20.349Z",
    "email": "user@test.com",
    "id": 1,
    "updated_at": "2020-10-10T05:43:20.349Z"
}
```

## 特性

#### 🚀 基于Rails 6

与`rails 5`不同，`rails 6`是未来发展的必然趋势。

#### 🚀 Rails API

使用流行前端的js库如`react`，`vuejs`，替换原来的`rails view`

#### 🚀 ActionCable

该项目演示了聊天的后端是如何使用JWT认证身份的actioncable，其功能如下：

- 用户可以
  - 创建/删除房间
  - 设置他/她的头像
- 其他用户可以加入房间
- 在房间内的用户可以
  - 互相发送消息
  - 更新消息
  - 删除消息
  - 发起其他人可以参加的投票
  - 随机选取房间内特定数量的用户

相关的fronend演示是用[react-pangu](https://github.com/ruilisi/react-pangu)编写，桥接前端和后端的js库是用的是[actioncable-jwt](https://github.com/ruilisi/actioncable-jwt)。

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

实现了将`devise`和`jwt`技术融合，虽然也有其他开发者通过其它方式实现了两者的融合运用，但都效果欠佳。

我们在 [app/models/jwt_denylist.rb](https://github.com/ruilisi/Rails-pangu/blob/master/app/models/jwt_denylist.rb) 里面通过使用redis实现了 devise-jwt的 `denylist strategy`。

#### 🚀 Postgres

使用postgres作为默认数据库。当一个Web服务器的流量变得很大时，sqlite3显然无法满足我们的需求。

#### 🚀 Rspec

Ruby行为驱动测试框架，让TDD高效有趣。

#### 🚀 [RuboCop](https://docs.rubocop.org)

Ruby代码静态分析和格式工具，基于社区Ruby样式准侧 

#### 🚀 [CircleCI](https://circleci.com/)

CircleCI是一个行业流行的持续集成和持续部署的开发工具，方便与团队成员之间代码交流，密切协作。
在本项目中，我们通过CircleCI用`rspec`和`RuboCop`来测试`Rails-pangu`的代码库。

#### 🚀 [Factory Bot](https://github.com/thoughtbot/factory_bothttps://github.com/thoughtbot/factory_bot)

将Ruby对象设置为测试用例。

#### 🚀 Docker

本项目中提供了Dockerfile和相关脚本来生成docker镜像。

本项目提供的Docker构建方案包含了两大优化: 

- Docker镜像构建加速

  当一个项目迭代增长时，上百甚至上千个Gem会被尝试或者使用。即使是对`Gemfile`的一个微小变动都会触发一次所有Gem的重新bundle，故而绝大部分bundle时间都浪费在去bundle绝大多数稳定的Gem，例如：`rails`, `pg`。为了解决这个问题，我们通过一个小技巧来加速docker构建过程。这个技巧就是分两次来bundle `Gemfile`，然后产生两层镜像文件：

  - 第一次为`Gemfile.core`构建镜像层，该文件服务于稳定或者核心的`Gem`，例如`rails`, `pg`。
  - 第二次为`Gemfile`构建镜像层，该文件服务于易于变化的或者非核心的`Gem`， 例如你自己写的或者forked项目。

  尽管这个过程会生成额外的Docker镜像层，使镜像变大（预计几百KB），但这样做是有意义的，因为程序运行时间比磁盘空间要有限得多。

  下面的`Dockerfile`代码片段演示了该镜像构建过程：

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

- Gem构建加速 (仅为中国开发者提供)

  我们会将Gem源 `https://rubygems.org` 镜像到 `https://gems.ruby-china.com`, 这会帮助中国开发者加速Gem构建速度。

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

## Test

```bash
rails db:reset db:seed RAILS_ENV="test"
rspec
```


## CORS

在默认情况下，`Rails-pangs`允许CORS并公开Authorization的Header。如果你想要禁用它，可以注释掉`config/cors.rb`文件的内容。



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

除了我们提供的默认角色之外，我们还允许developer创建他们的[自定义角色](https://github.com/ruilisi/Rails-pangu/wiki/create-a-role)。

## Denylist

#### 默认redis黑名单

由于redis的访问内存的性能极高，redis是用来实现`denylist`的一个好的选择。在`jwt_denylist`中，我们用redis实现了黑名单。通过将`redis`的过期时间设置为与`jwt token`的过期时间相同，可以在令牌过期时自动从redis中删除此令牌。

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



#### 自定义黑名单

你也可以通过自己的策略实现黑名单。你只需要重写两个方法：`jwt-revoked？`以及`jwt-denylist.rb`中的`revoke-jwt`，这两个方法都接受jwt负载和`user`记录作为参数。

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

## 使用Rails-pangu的一些项目

- **[LINGTI](https://lingti.io)**  (https://lingti.io/): 灵缇加速器是一款游戏加速器，包含PC、iOS、Android客户端。灵缇iOS和Android客户端支持Switch游戏热点加速，让你享受极致的联机和下载体验。灵缇PC客户端支持加速Switch、万智牌、LOL英雄联盟、DOTA2、绝地求生、CSGO等热门中外网游。
- **[eSheep](https://esheep.io)**  (https://esheep.io/): 电子绵羊eSheep是一款网络加速器，它可以帮助身在海外的您极速连接中国的视频音乐网站。

[<img src="https://assets.lingti.paiyou.co/ed568fbe.png" width="150" align="middle" />](https://lingti.io) [<img src="https://res.paiyou.co/44920709.png" width="200" align="middle" />](https://lingti.io)

## 执照

代码和文档版权归2019年[MIT许可](https://github.com/ruilisi/rails-pangu/blob/master/LICENSE)下发布的[Rails-pangu Authors](https://github.com/ruilisi/rails-pangu/graphs/contributors) 和 [Paiyou Network](https://paiyou.co/)所拥有。

## Contributors ✨

致谢 ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

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

该项目遵循[贡献者](https://github.com/all-contributors/all-contributors)规范。欢迎任何形式的捐助！
