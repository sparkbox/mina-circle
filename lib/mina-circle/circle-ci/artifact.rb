require 'uri'

class CircleCI::Artifact
  attr_reader :response_object, :build
  def initialize(hash)
    @response_object = hash
  end

  def filename
    File.basename response_object['path']
  end

  def url
    URI(response_object.fetch('url', ''))
  end

  def contains_valid_url?
    url.kind_of?(URI::HTTP) or url.kind_of?(URI::HTTPS)
  end
end
