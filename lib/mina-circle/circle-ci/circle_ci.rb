class CircleCI
  def self.artifact_url
    project.artifacts.detect { |artifact|
      artifact.filename == circle_artifact
    }.url
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
