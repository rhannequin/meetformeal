# Install

## Ubuntu

### Create new user

```sh
$ adduser rhannequin
$ gpasswd -a rhannequin sudo
```

### Configure SSH

```sh
$ ssh-keygen -t rsa
```

From your local computer, add your SSH public key to your remove server:

```sh
$ ssh-copy-id rhannequin@my-server.com
```

* change SSH port (optional)
* Restrict root login
* Forbid password authentication (optional)

```sh
// vi /etc/ssh/sshd_config

Port 4444
PermitRootLogin no
PasswordAuthentication no
```

Restart SSH : `$ service ssh restart`

## [Fail2ban](http://doc.ubuntu-fr.org/fail2ban)

```sh
$ sudo apt-get install fail2ban
```

## Firewall ([ufw](http://doc.ubuntu-fr.org/ufw))

```sh
$ sudo ufw allow 80
$ sudo ufw allow 443
$ sudo ufw enable
```
## [Logwatch](http://doc.ubuntu-fr.org/logwatch)

```sh
$ apt-get install logwatch
```

Then edit `/etc/cron.daily/00logwatch` file and add this line:

```
/usr/sbin/logwatch --output mail --mailto name@example.com --detail high
```

## Ruby

### System dependencies

```
$ sudo apt-get install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev g++ libsqlite3-dev libpq-dev
```

See [Ruby installation](https://github.com/rhannequin/upgrade-ubuntu#ruby).

## MongoDB

```sh
$ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
$ echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
$ sudo apt-get update
$ sudo apt-get install -y mongodb-org
```

Edit the configuration file `/etc/mongod.conf` and ensure to enable those parameters:

```
auth = true
httpinterface = false
```

Launch `$ mongo` and create admin and user:

```
> use admin
> db.createUser({ user: 'admin', pwd: 'xxx', roles: [{ role: 'userAdminAnyDatabase', db: 'admin' }] })
> db.auth('admin', 'xxx')
> use my_database
> db.createUser({ user: 'xxx', pwd: 'xxx', roles: [{ role: 'readWrite', db: 'xxx' }] })
```
