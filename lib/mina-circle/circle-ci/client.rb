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
  unless File.exists?(CONFIG_FILE_PATH)
    puts "Please follow the setup steps (https://github.com/sparkbox/mina-circle#setup) and create a token."
    exit
  end
  attr_writer :api_token

  def get(path, params = {})
    uri = URI("#{BASE_URI}/#{path}")
    params['circle-token'] = api_token
    uri.query = URI.encode_www_form(params) unless params.empty?
    puts "Sending URL: #{uri}"
    request = Net::HTTP::Get.new uri
    request['Accept'] = 'application/json'
    response = Net::HTTP.start uri.host, uri.port, use_ssl: true do |http|
      http.request request
    end
    return_object = JSON.parse response.body

    JSON.pretty_generate return_object

    if return_object.instance_of? Object
      if return_object['message']
        puts return_object['message']
        puts "Check your branch and/or build on CircleCI..."
        exit
      end
    end

    return_object
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
