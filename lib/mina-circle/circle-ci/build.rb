class CircleCI::Build
  attr_reader :job_name, :build_number, :status, :project
  def initialize(hash, project)
    @job_name = hash['workflows']['job_name']
    @build_number = hash['build_num']
    @status = hash['status']
    @project = project
  end

  def artifacts
    api_path = [
      'project',
      project.vcs_type,
      project.organization,
      project.name,
      build_number,
      'artifacts'
    ].join '/'
    client = CircleCI::Client.instance
    response = client.get(api_path)
    response.collect { |artifact| CircleCI::Artifact.new artifact }
  end
end
