source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.0'

# MongoDB driver
gem 'mongoid', '~> 4.0.0'
gem 'bson_ext'

# Authentication
gem 'devise'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'

# Environment configuration
gem 'figaro'

# Assets
## Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
## Bootstrap
gem 'bootstrap-sass'
## Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
## Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
## See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Ajax
## Use jquery as the JavaScript library
gem 'jquery-rails'
## Turbolinks makes following links in your web application faster
gem 'turbolinks'
## Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
## Use respond_to and respond_with methods
gem 'responders', '~> 2.0'

# Simple Form
gem 'simple_form'

group :development, :test do
  gem 'rspec-rails', '~> 3.0'         # RSpec test framework
  gem 'mongoid-rspec', '~> 2.0.0.rc1'
  gem 'factory_girl_rails'            # Factories
  gem 'capybara'                      # Integration tests
  gem 'faker'                         # Use real values to fake for factories
  gem 'web-console', '~> 2.0'         # Web Console
  gem 'i18n-tasks'                    # Finds and manage missing and unused translations
end

group :development do
  gem 'spring'                        # Keeps application running in the background
  gem 'quiet_assets'                  # Turns off the Rails asset pipeline log
  gem 'rubocop'
end

group :test do
  gem 'database_cleaner'              # Clean database during tests
  gem 'simplecov', require: false  # Test coverage
end

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
