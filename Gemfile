# frozen_string_literal: true

source 'https://rubygems.org'
gem 'babosa'
gem 'carrierwave'
gem 'carrierwave-datamapper'
gem 'data_mapper'
gem 'dm-aggregates'
gem 'dm-constraints'
gem 'dm-core'
gem 'dm-migrations'
gem 'dm-sqlite-adapter'
gem 'dm-timestamps'
gem 'dm-validations'
gem 'haml'
gem 'pony'
gem 'rake'
gem 'sinatra', '>= 1.0'

group :production do
  gem 'unicorn'
end
group :development do
  # gem 'capistrano', '~> 2.15.5'
  gem 'capistrano', '~> 3.0', require: false
  gem 'capistrano-bundler', '~> 1.1', require: false
  gem 'capistrano-rvm'
end

# group :test do
gem 'rack-test'
gem 'rspec', require: 'spec'
# end
