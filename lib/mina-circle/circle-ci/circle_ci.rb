class CircleCI
  def self.artifact_url
    artifact = project.artifacts.detect { |a|
      a.filename == circle_artifact
    }
    raise 'Missing or invalid URL from CircleCI' unless artifact.contains_valid_url?
    artifact.url.to_s
  end

  def self.project
    @@project ||= CircleCI::Project.new organization: circle_user, project: circle_project, branch: branch
  end

  def self.project=(project)
    @@project = project
  end

  def self.circle_artifact=(circle_artifact)
    @@circle_artifact = circle_artifact
  end

  def self.circle_artifact
    @@circle_artifact ||= fetch(:circle_artifact)
  end
end
