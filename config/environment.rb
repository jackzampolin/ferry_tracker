# Set up gems listed in the Gemfile.
# See: http://gembundler.com/bundler_setup.html
#      http://stackoverflow.com/questions/7243486/why-do-you-need-require-bundler-setup
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

# Require gems we care about
require 'rubygems'
require 'uri'
require 'pathname'
require 'pg'
require 'active_record'
require 'logger'
require 'sinatra'
require "sinatra/reloader" if development?
require 'erb'

# Some helper constants for path-centric logic
APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
APP_NAME = APP_ROOT.basename.to_s

configure do
  # By default, Sinatra assumes that the root is the file that calls the configure block.
  # Since this is not the case for us, we set it manually.
  set :root, APP_ROOT.to_path
  # See: http://www.sinatrarb.com/faq.html#sessions
  enable :sessions
  set :session_secret, ENV['SESSION_SECRET'] || 'this is a secret shhhhh'

  # Set the views to
  set :views, File.join(Sinatra::Application.root, "app", "views")
end

# Set up the controllers and helpers
Dir[APP_ROOT.join('app', 'controllers', '*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app', 'helpers', '*.rb')].each { |file| require file }

# Set up the database and models
require APP_ROOT.join('config', 'database')

# API Keys
SF_POINTS = [[37.793983, -122.415663],[37.794641, -122.439307],[37.781753, -122.461795],[37.779040, -122.485141],[37.757158, -122.495977],[37.749015, -122.481558],[37.758380, -122.467653],[37.782533, -122.406370],[37.773443, -122.429888],[37.757294, -122.414781],[37.749422, -122.439501]]

HEX_COLOR_ARRAY = ['#1B1EA1','#201D9C','#261D98','#2C1C94','#321C90','#381B8C','#3E1B87','#441A83','#4A1A7F','#50197B','#561977','#5C1872','#62186E','#68186A','#6E1766','#741762','#7A165D','#801659','#861555','#8C1551','#92144D','#981448','#9E1344','#A41340','#AA133C','#B01238','#B61233','#BC112F','#C2112B','#C81027','#CE1023','#D40F1E','#DA0F1A','#E00E16','#E60E12','#EC0E0E']

MAPS_API = 'AIzaSyBW4WDutEs6-CA0tZsrjIBYU8Y2WfrO8x0'
WUAPI_KEY = '615f6d0dc69178d0'