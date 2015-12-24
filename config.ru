#!/usr/bin/env ruby
require 'rubygems'
require 'gollum/app'

module Precious
  class App < Sinatra::Base
    basic_auth_username = ENV['BASIC_AUTH_USERNAME']
    basic_auth_password = ENV['BASIC_AUTH_PASSWORD']
    if basic_auth_username && basic_auth_password
      before do
        authorize
      end
    end

    private
    def authorize
      response['WWW-Authenticate'] = %(Basic realm="Restricted area.")
      throw(:halt, [401, "Not authorized\n"]) unless authorized?
    end

    def authorized?
      basic_auth_username = ENV['BASIC_AUTH_USERNAME']
      basic_auth_password = ENV['BASIC_AUTH_PASSWORD']

      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [basic_auth_username, basic_auth_password]
    end
  end
end

#gollum_path = File.expand_path(File.dirname(__FILE__)) # CHANGE THIS TO POINT TO YOUR OWN WIKI REPO
gollum_path = '/tmp/gollumwiki'

wiki = Gollum::Wiki.new(gollum_path)
Gollum::Hook.register(:post_commit, :hook_id) do |committer, sha1|
  wiki.repo.git.pull("origin", "master")
  wiki.repo.git.push("origin", "master")
end

wiki_options = {:universal_toc => true}
Precious::App.set(:gollum_path, gollum_path)
Precious::App.set(:default_markup, :markdown) # set your favorite markup language
Precious::App.set(:wiki_options, wiki_options)
run Precious::App
