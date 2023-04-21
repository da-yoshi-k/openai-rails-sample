require 'google/cloud/language'
require 'base64'
require 'json'

# Configure Google Cloud Language
Google::Cloud::Language.configure do |config|
  encoded_json = ENV['GOOGLE_APPLICATION_CREDENTIALS_BASE64']
  json = Base64.decode64(encoded_json)
  config.credentials = JSON.parse(json)
end
