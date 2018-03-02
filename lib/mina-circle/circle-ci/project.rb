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
    api_path_parts.join('/')
  end

  def build_path
    parts = api_path_parts + ['tree', real_branch]
      
    parts.compact.join('/')
  end

  private

  def api_path_parts
    [
      'project',
      vcs_type,
      organization,
      name
    ]
  end

  def real_branch
    branch || 'master'
  end

  def fetch_artifacts
    # To support Circle 2.0
    build_info = CircleCI::Client.instance.get "#{build_path}", filter: 'successful', has_artifacts: true

    build_num = 'latest' # circle version 1.0

    if build_info.first['previous_successful_build']['build_num']
      build_num = build_info.first['previous_successful_build']['build_num']
    end

    puts "Using Build: #{build_num}"

    artifact_hashes = CircleCI::Client.instance.get "#{api_path}/#{build_num}/artifacts", filter: 'successful', branch: real_branch
    artifact_hashes.collect { |artifact_hash|
      CircleCI::Artifact.new artifact_hash
    }
  end
end
