require 'logger'

module Precious
  class App < Sinatra::Base
    logger = Logger.new(STDERR)
    basic_auth_username = ENV['BASIC_AUTH_USERNAME']
    basic_auth_password = ENV['BASIC_AUTH_PASSWORD']
    if basic_auth_username && basic_auth_password
      logger.info('Enabled basic auth')
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

