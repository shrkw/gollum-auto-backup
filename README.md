# gollum-auto-backup
gollum with automatic BitBucket backup via Gollum::Hook

This repo is folked from [naoa/gollum-on-heroku](https://github.com/naoa/gollum-on-heroku), for further more detail [Deploy to HerokuボタンでGitベースのWiki gollumを無料で簡単に作れるようにした - CreateField Blog](http://blog.createfield.com/entry/2015/09/21/214232).

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

## Additional features

- Basic Auth
- BitBucket backup via Post commit hook

## Usage

1. `heroku create`
1. `heroku buildpacks:set https://github.com/heroku/heroku-buildpack-multi.git`
1. `heroku config:add FOLLOWING_CONFIGS`
1. `git push heroku master`

## Required Config

- AUTHOR_EMAIL
- AUTHOR_NAME
- GIT_REPO_PATH: e.g.) shrkwh/private_repo_sandbox
- OAUTH_KEY
- OAUTH_SECRET
