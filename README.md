# Funky Starter Plus Plus

This is a fork from [Funky Starter](https://github.com/rhannequin/funky-starter) project with a few more features:

- [Bootstrap](https://github.com/twbs/bootstrap-sass) integration
- [Simple Form](https://github.com/plataformatec/simple_form)
- Devise custom view with Simple Form and Bootstrap
- [i18n-tasks](https://github.com/glebm/i18n-tasks) and improvements in translations
- [Rubocop](https://github.com/bbatsov/rubocop)

Please check [Funky Starter](https://github.com/rhannequin/funky-starter) for more information.

## Current issues

This project is *under development* and **really** not ready yet. Here are some issues I am currently working on to:

* [Rails Mongoid fails to authenticate](http://stackoverflow.com/questions/29875839/rails-mongoid-fails-to-authenticate-failed-with-error-13-not-authorized-for)
* [Empty environment variables after deployment](https://github.com/laserlemon/figaro/issues/210)

## Usage

```sh
$ git clone https://github.com/rhannequin/funky-starter-plus-plus
$ cd funky-starter-plus-plus
$ bundle install
$ bundle exec rake fork[/home/xxx/my-new-project]
```
