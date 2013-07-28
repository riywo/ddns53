# DDNS53

Update Route53 as a Dynamic DNS

## Purpose

Automatically update your Route53 A record to access your home network servers just requesting GET to your heroku app. DDNS53 uses `REMOTE_ADDR` as your home network global IP address, that is, DDNS53 is assuming your home network is configured using the same IP address outbound and inbound.

## Installation

First, create your heroku account and install Heroku Toolbelt. See [https://devcenter.heroku.com/articles/quickstart](https://devcenter.heroku.com/articles/quickstart)

    $ git clone https://github.com/riywo/ddns53
    $ cd ddns53
    $ heroku create
    $ heroku config:set DDNS53_USER="user" DDNS53_PASS="pass"
    $ heroku config:set AWS_ACCESS_KEY_ID="..." AWS_SECRET_ACCESS_KEY="..."
    $ heroku config:set DDNS53_FQDN="www.yourdomain.com,blog.yourdomain.com"
    $ git push heroku master
    $ open http://yourheroku.com

## Usage

From a server in your LAN:

    $ curl -s --digest -u user:pass http://yourheroku.com/www.yourdomain.com
    $ curl -s --digest -u user:pass http://yourheroku.com/blog.yourdomain.com

Set the same commands on your server's crontab, Jenkins, etc.

## Configuration

All configurations are environment variables. In production(heroku), you can use `heroku config:set/unset` to change the values.

### `DDNS53_USER`,`DDNS53_PASS`

**Mandatory**

username and password for the digest authentication.

### `AWS_ACCESS_KEY_ID`,`AWS_SECRET_ACCESS_KEY`

**Mandatory**

your aws access credentials.

### `DDNS53_FQDN`

**Mandatory**

FQDN list which can be updated by DDNS53.

### `DDNS53_TTL`

If you set this option, DDNS53 updates TTL of records as the value. Default value is 300.

## License

MIT

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
