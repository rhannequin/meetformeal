# Install

## Ubuntu

### Create new user

```sh
$ adduser rhannequin
$ gpasswd -a rhannequin sudo
```

### Configure SSH

```sh
$ ssh-keygen
```

* change SSH port (optional)
* Restrict root login

```sh
// vi /etc/ssh/sshd_config

Port 4444
PermitRootLogin no
```

Restart SSH : `$ service ssh restart`

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
```

Launch `$ mongo` and create admin and user:

```
> db.createUser({ user: 'admin', pwd: 'xxx', roles: [{ role: 'userAdminAnyDatabase', db: 'admin' }] })
> db.auth('admin', 'xxx')
> use my_database
> db.createUser({ user: 'xxx', pwd: 'xxx', roles: [{ role: 'readWrite', db: 'xxx' }] })
```
