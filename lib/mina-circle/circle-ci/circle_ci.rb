class CircleCI
  def self.artifact_url(settings = {})
    project = CircleCI::Project.new(
      organization: settings[:circleci_user],
      name: settings[:circleci_project],
      branch: settings[:branch]
    )

    artifact = project.artifacts.detect { |a|
      a.filename == settings[:circleci_artifact]
    }
    raise 'Missing or invalid URL from CircleCI' unless artifact.contains_valid_url?
    base_url = artifact.url
    base_url.query = URI.encode_www_form({ 'circle-token' => CircleCI::Client.instance.api_token })
    base_url.to_s
  end
end
