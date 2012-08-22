# 简介

{<img src="https://secure.travis-ci.org/lidaobing/backup2everbox.png?branch=master" alt="Build Status" />}[http://travis-ci.org/lidaobing/backup2everbox]

备份你的数据、文件到 EverBox

文档: http://rubydoc.info/github/lidaobing/backup2everbox/master/frames

# 使用方法

1. 注册一个 EverBox 帐号: http://www.everbox.com

2. 运行 `gem install backup2everbox`

3. 运行 `backup generate:config`

4. 运行 `backup generate:model --trigger=mysql_backup_everbox`

5. 运行 `backup2everbox`, 得到认证码，输出如下所示

  ```
  open url in your browser: http://account.everbox.com/...
  please input the verification code: 123456

  add following code to your ~/Backup/models/foo.rb
  ##################################################
    store_with Everbox do |eb|
      eb.token     = '1234567890abcdefgh'
      eb.secret    = 'hgfedcba0987654321'
    end
  ##################################################
  ```

6. 修改 `~/Backup/models/mysql_backup_everbox.rb`, 改为如下的形式

  ```ruby
  require 'rubygems'
  gem 'backup2everbox'
  require 'backup2everbox'

  Backup::Model.new(:mysql_backup_everbox, 'Description for mysql_backup_everbox') do
    split_into_chunks_of 250

    database MySQL do |db|
      db.name               = "giga_development"
      db.username           = "my_username"
      db.password           = "my_password"
      db.host               = "localhost"
      db.port               = 3306
      db.socket             = "/tmp/mysql.sock"
    end

    store_with Everbox do |eb|
      eb.token     = '1234567890abcdefgh'
      eb.secret    = 'hgfedcba0987654321'
    end
  end
  ```

7. 运行 `backup perform -t mysql_backup_everbox`

8. backup 支持备份目录，数据库等多种源，并且支持非对称密钥加密来保护数据安全，
   具体可以参考 backup 的文档: https://github.com/meskyanichi/backup
