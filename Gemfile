# frozen_string_literal: true

source 'https://rubygems.org'
gem 'babosa'
gem 'carrierwave'

# older version doesn't create db table to store file path
# but this is good
gem 'carrierwave-datamapper','~> 0.2.0'


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
gem 'rake', '>= 12.3.3'
gem 'sinatra', '>= 1.0'
gem 'liqpay', github: 'liqpay/sdk-ruby'

group :production do
  gem 'unicorn'
end
group :development do
  gem 'capistrano', '~> 2.15.5'
end

# group :test do
gem 'rack-test'
gem 'rspec', require: 'spec'
# end
