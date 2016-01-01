#!/usr/bin/env ruby
require 'rubygems'
require 'gollum/app'

require './precious'

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
