require './bitbucket'

class App
  def initialize
    @repo_path = ENV['GIT_REPO_PATH']
#    @oauth_token = ENV['OAUTH_TOKEN']
    @author_email = ENV['AUTHOR_EMAIL']
    @author_name = ENV['AUTHOR_NAME']
    @oauth_key = ENV['OAUTH_KEY']
    @oauth_secret = ENV['OAUTH_SECRET']

    @gollum_h1_title = ENV['GOLLUM_H1_TITLE'] ? !ENV['GOLLUM_H1_TITLE'].downcase.eql?("false".downcase) : true
    @gollum_universal_toc = ENV['GOLLUM_UNIVERSAL_TOC'] ? !ENV['GOLLUM_UNIVERSAL_TOC'].downcase.eql?("true".downcase) : true
    @gollum_allow_editing = ENV['GOLLUM_ALLOW_EDITING'] ? !ENV['GOLLUM_ALLOW_EDITING'].downcase.eql?("false".downcase) : true
    @gollum_live_preview = ENV['GOLLUM_LIVE_PREVIEW'] ? !ENV['GOLLUM_LIVE_PREVIEW'].downcase.eql?("true".downcase) : false
    @gollum_allow_uploads = ENV['GOLLUM_ALLOW_UPLOADS'] ? !ENV['GOLLUM_ALLOW_UPLOADS'].downcase.eql?("false".downcase) : true
    @gollum_show_all = ENV['GOLLUM_SHOW_ALL'] ? !ENV['GOLLUM_SHOW_ALL'].downcase.eql?("false".downcase) : true
    @gollum_collapse_tree = ENV['GOLLUM_COLLAPSE_TREE'] ? !ENV['GOLLUM_COLLAPSE_TREE'].downcase.eql?("true".downcase) : true
    @gollum_is_bare = ENV['GOLLUM_IS_BARE'] ? !ENV['GOLLUM_IS_BARE'].downcase.eql?("true".downcase) : false

    @gollum_user_icons = 'none'
    @gollum_css = true
    @gollum_js = true
    @gollum_template_dir = nil

#    `git config --global credential.helper store`
#    if @oauth_token
#      if @repo_url.include?("github.com")
#        `echo https://#{@oauth_token}:x-oauth-basic@github.com > ~/.git-credentials`
#      elsif @repo_url.include?("bitbucket.org")
#        `echo https://x-token-auth:#{@oauth_token}@bitbucket.org > ~/.git-credentials`
#      end
#    end
    @oauth_token = fetch_access_token(@oauth_key, @oauth_secret)
    @repo_url = "https://x-token-auth:#{@oauth_token}@bitbucket.org/#{@repo_path}"
  end

  def wiki_options
    {
      css: @gollum_css,
      js: @gollum_js,
      allow_editing: @gollum_allow_editing,
      live_preview: @gollum_live_preview,
      allow_uploads: @gollum_allow_uploads,
      h1_title: @gollum_h1_title,
      show_all: @gollum_show_all,
      collapse_tree: @gollum_collapse_tree,
      user_icons: @gollum_user_icons,
      template_dir: @gollum_template_dir,
      universal_toc: @gollum_universal_toc,
      repo_is_bare: @gollum_is_bare
    }
  end

  def set_repo
    @repo_name = File.basename(@repo_url)
    unless File.exists?(@repo_name)
      git = Grit::Git.new(@repo_name)
      git.clone({branch: 'master', bare: @gollum_is_bare}, @repo_url, @repo_name)
#        if @oauth_token && !File.exists?(repo_name)
#          create_repo(repo_name)
#          git.clone({branch: 'master', bare: @gollum_is_bare}, @repo_url, repo_name)
#        end
    end
    repo = Grit::Repo.new(@repo_name, {is_bare: @gollum_is_bare})
    raise "Not found repository" unless repo

    repo.config['user.email'] = @author_email
    repo.config['user.name'] = @author_name
  end

  def set_hook
    return unless @oauth_token
    wiki = Gollum::Wiki.new(@repo_name)
    Gollum::Hook.register(:post_commit, :hook_id) do |committer, sha1|
#      wiki.repo.git.pull("origin", "master")
      wiki.repo.git.push("origin", "master")
    end
  end

  def repo_name
    @repo_name
  end
end
