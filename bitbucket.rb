require 'net/http'
require 'uri'
require 'openssl'
require 'json'

def fetch_access_token(key, secret)
  url = URI.parse('https://bitbucket.org/site/oauth2/access_token')
  req = Net::HTTP::Post.new(url.path)

  req.basic_auth key, secret
  req.set_form_data({'grant_type'=>'client_credentials'}, ';')
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  #http.set_debug_output $stderr
  res = http.start {|http| http.request(req) }
  case res
  when Net::HTTPSuccess, Net::HTTPRedirection
    js = JSON.parse(res.body)
    js['access_token']
  else
    raise StandardError, 'raise'
  end
end
