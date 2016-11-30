class CircleCI::Project
  attr_writer :artifacts
  attr_reader :vcs_type, :organization, :name, :branch
  def initialize(organization:, name:, branch:, vcs_type: 'github')
    @organization = organization
    @name = name
    @vcs_type = vcs_type
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
    artifact_hashes = CircleCI::Client.instance.get "#{api_path}/latest/artifacts", filter: 'successful', branch: branch
    artifact_hashes.collect { |artifact_hash|
      CircleCI::Artifact.new artifact_hash
    }
  end
end
