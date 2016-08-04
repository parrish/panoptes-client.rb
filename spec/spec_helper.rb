$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'panoptes-client'

require 'webmock/rspec'
require 'vcr'
require 'timecop'
require 'pry'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr'
  config.hook_into :webmock
  config.configure_rspec_metadata!

  config.filter_sensitive_data("<ACCESS_TOKEN>") { test_access_token }
  config.filter_sensitive_data("<CLIENT_ID>")    { test_client_id }
  config.filter_sensitive_data("<CLIENT_SECRET") { test_client_secret }
end

def test_url;           ENV.fetch("ZOONIVERSE_URL",           'https://panoptes-staging.zooniverse.org'); end
def test_talk_url;      ENV.fetch("ZOONIVERSE_TALK_URL",      'https://talk-staging.zooniverse.org'); end
def test_access_token;  ENV.fetch("ZOONIVERSE_ACCESS_TOKEN",  'x'*64); end
def test_client_id;     ENV.fetch("ZOONIVERSE_CLIENT_ID",     'x'*64); end
def test_client_secret; ENV.fetch("ZOONIVERSE_CLIENT_SECRET", 'x'*64); end

def unauthenticated_client
  Panoptes::Client.new(url: test_url)
end

def application_client
  Panoptes::Client.new(
    url: test_url,
    auth_url: test_url,
    auth: { client_id: test_client_id, client_secret: test_client_secret }
  )
end

def user_client
  Panoptes::Client.new(
    url: test_url,
    auth_url: test_url,
    public_key_path: File.expand_path("../../data/doorkeeper-jwt-staging.pub", __FILE__),
    auth: { token: test_access_token }
  )
end

def talk_client
  Panoptes::TalkClient.new(url: test_talk_url)
end

def api_url(path)
  test_url + "/api" + path
end

def talk_api_url(path)
  test_talk_url + path
end
