# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

require 'mongoid'
require 'haml'
require 'ostruct'
require 'carrierwave'
require 'carrierwave/mongoid'
# require 'rmagick'
require 'json'
require 'babosa'
require 'pony'
require 'liqpay'
require 'date'

require 'sinatra' unless defined?(Sinatra)

require_relative 'settings.rb'

configure do
  SiteConfig = OpenStruct.new(SETTINGS)

  Mongoid.load!("#{File.dirname(__FILE__)}/config/mongoid.yml")

  ::Liqpay.configure do |config|
    config.public_key = SiteConfig.pb_public_key
    config.private_key = SiteConfig.pb_private_key
  end

  # load models
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/models")
  Dir.glob("#{File.dirname(__FILE__)}/models/*.rb") { |model| require File.basename(model, '.*') }

  set :views, "#{File.dirname(__FILE__)}/views"

  set :logger, Logger.new(STDOUT)
end

error do
  e = request.env['sinatra.error']
  Kernel.puts e.backtrace.join("\n")
  'Application error'
end

helpers do
  # add your helpers here
end

enable :sessions
