class CircleCI::Artifact
  attr_reader :response_object, :build
  def initialize(hash)
    @response_object = hash
  end

  def filename
    File.basename response_object['path']
  end

  def url
    response_object['url']
  end
end
