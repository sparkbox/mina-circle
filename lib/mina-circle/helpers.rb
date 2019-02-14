require 'uri'
module MinaCircle
  module Helpers
    def artifact_url
      project = CircleCI::Project.new(
        organization: settings[:circleci_user],
        name: settings[:circleci_project]
      )

      recent_builds = project.recent_builds settings[:branch]

      successful_for_job =
        recent_builds
          .select { |build| build.status == 'success' && build.job_name == settings[:circleci_job_name] }
          .sort { |a, b| a.build_number <=> b.build_number }

      build_artifacts = successful_for_job.last.artifacts

      build_artifacts.find { |artifact| artifact.filename == settings[:circleci_artifact] }
    rescue RuntimeError => e
      puts "Unable to determine url for deployment artifact"
      puts e.message
    end

    def options_whitelist
      [
        :branch
      ]
    end
  end
end
