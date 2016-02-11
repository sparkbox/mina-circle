module MinaCircle
  module Helpers
    def build_url
      latest_build = circle_ci.builds.first
      circle_ci.artifacts(latest_build).select { |artifact|
        artifact.filename == circle_artifact
      }.first.url
    end

    def circle_ci
      @circle_ci ||= CircleCI.new circle_user, circle_project, branch
    end
  end
end

