module MinaCircle
  module Helpers
    def build_url
      latest_build = circle_ci.builds.first
      artifacts = circle_ci.artifacts(latest_build).select { |artifact|
        artifact.filename == circle_artifact
      }
      raise "No artifacts found for build: #{latest_build.build_num} on #{branch}. #{latest_build.status}" if artifacts.empty?
      artifacts.first.url
    rescue Exception => e
      puts e.message
      puts ""
      puts "Review your build at to ensure artifacts are being captured as described in https://circleci.com/docs/build-artifacts/"
    end

    def circle_ci
      @circle_ci ||= CircleCI.new circle_user, circle_project, branch
    end
  end
end

