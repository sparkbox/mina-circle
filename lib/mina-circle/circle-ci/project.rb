class CircleCI::Project
  attr_writer :artifacts
  attr_reader :vcs_type, :organization, :name
  def initialize(organization:, name:, vcs_type: 'github')
    @organization = organization
    @name = name
    @vcs_type = vcs_type
  end

  def build_path
    parts = api_path_parts + ['tree', real_branch]
      
    parts.compact.join('/')
  end

  def recent_builds(branch)
    client = CircleCI::Client.instance
    path = api_path branch
    response = client.get path
    builds = response.collect { |build| CircleCI::Build.new(build, self) }
    builds.compact
  end

  private

  def api_path(branch)
    [
      'project',
      vcs_type,
      organization,
      name,
      'tree',
      branch
    ].join('/')
  end

  def real_branch
    branch || 'master'
  end
end
