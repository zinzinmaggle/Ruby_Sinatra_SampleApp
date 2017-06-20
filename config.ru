require './config/environment'
require 'sass/plugin/rack'
require File.dirname(__FILE__) + '/app'

Sass::Plugin.add_template_location('app/stylesheets')

use Sass::Plugin::Rack
use Rack::Static, urls: ['/stylesheets'], root: 'public'

run MyApp
