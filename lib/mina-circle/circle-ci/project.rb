class CircleCI::Project
  attr_writer :artifacts
  attr_reader :vcs_type, :organization, :name, :branch
  def initialize(organization:, name:, branch:, vcs_type: 'github')
    @organization = organization
    @name = name
    @vcs_type = vcs_type
    @branch = branch
  end

  def artifacts
    @artifacts ||= fetch_artifacts
  end

  def api_path
    [
      'project',
      vcs_type,
      organization,
      name
    ].join('/')
  end

  private

  def fetch_artifacts
    # To support Circle 2.0
    build_info = CircleCI::Client.instance.get "#{api_path}", filter: 'successful', branch: branch ? branch : 'master', has_artifacts: true

    build_num = 'latest' # circle version 1.0

    if build_info.first['previous_successful_build']['build_num']
      build_num = build_info.first['previous_successful_build']['build_num']
    end

    puts "Using Build: #{build_num}"

    artifact_hashes = CircleCI::Client.instance.get "#{api_path}/#{build_num}/artifacts", filter: 'successful', branch: branch ? branch : 'master'
    artifact_hashes.collect { |artifact_hash|
      CircleCI::Artifact.new artifact_hash
    }
  end
end
