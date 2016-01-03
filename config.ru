#!/usr/bin/env ruby
require 'rubygems'
require 'gollum/app'

require './precious'
require './app'
require './macros'

extend Gollum

$stdout.sync = true

app = App.new
app.set_repo
app.set_hook

Precious::App.set(:gollum_path, app.repo_name)
Precious::App.set(:default_markup, :markdown) # set your favorite markup language
Precious::App.set(:wiki_options, app.wiki_options)
run Precious::App
