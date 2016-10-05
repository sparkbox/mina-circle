require 'open-uri'

class CircleCI
  BASE_URI = 'https://circleci.com/api/v1'
  attr_accessor :organization, :project, :branch
  def initialize(organization, project, branch = 'master')
    @organization = organization
    @project = project
    @branch = branch
  end

  def builds
    get("tree/#{branch}").collect { |build_hash| Build.new(build_hash) }
  end

  def artifacts(build)
    puts "Build: #{build.build_num}"
    begin
      return get("#{build.build_num}/artifacts").collect { |artifact_hash| Artifact.new(artifact_hash) }
    rescue
      puts "No artifacts found for build #{build.build_num} on #{@branch}"
    end
  end

  def get(path)
    url = build_url path
    JSON.parse(open(url).read)
  rescue OpenURI::HTTPError
    []
  end

  def build_url(path)
    url = "#{BASE_URI}/project/#{organization}/#{project}/#{path}"
    url << "?circle-token=#{CircleCI.token}" if CircleCI.token
    url
  end

  def self.token
    @@token ||= get_token
  end

  def self.get_token
    return ENV['MINA_CIRCLE_TOKEN'] if ENV['MINA_CIRCLE_TOKEN']
    config_file = File.join(Dir.home, '.mina-circle.yml')
    File.exist?(config_file) ? YAML.load_file(config_file)['token'] : nil
  end

  class Artifact
    attr_reader :source_url, :filename
    def initialize(hash)
      @filename = File.basename hash['path']
      @source_url = hash['url']
    end

    def url
      CircleCI.token.nil? ? source_url : "#{source_url}?circle-token=#{CircleCI.token}"
    end
  end

  class Build
    attr_reader :build_num
    def initialize(hash)
      @build_num = hash['build_num']
    end
  end
end
