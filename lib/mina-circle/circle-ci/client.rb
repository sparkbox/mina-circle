require 'singleton'
require 'uri'
require 'net/http'
require 'base64'
require 'yaml'
require 'json'

class CircleCI::Client
  include Singleton
  BASE_URI = 'https://circleci.com/api/v1.1'
  CONFIG_FILE_PATH = File.join(Dir.home, '.mina-circle.yml')
  attr_writer :api_token

  def get(path, params = {})
    uri = URI("#{BASE_URI}/#{path}")
    uri.query = URI.encode_www_form(params) unless params.empty?
    request = Net::HTTP::Get.new uri
    request['Accept'] = 'application/json'
    request['Authorization'] = "Basic #{Base64.encode64(api_token).chomp}"
    response = Net::HTTP.start uri.host, uri.port, use_ssl: true do |http|
      http.request request
    end
    JSON.parse response.body
  end

  def api_token
    [
      @api_token,
      ENV['MINA_CIRCLE_TOKEN'],
      system_token
    ].compact.first
  end

  private

  def system_token
    File.exist?(CONFIG_FILE_PATH) ? YAML.load_file(CONFIG_FILE_PATH)['token'] : nil
  end
end
