require 'uri'
module MinaCircle
  module Helpers
    def artifact_fetch_command
      project = CircleCI::Project.new(
        organization: settings[:circleci_user],
        name: settings[:circleci_project]
      )

      recent_builds = project.recent_builds settings[:branch]

      successful_for_job =
        recent_builds
          .select { |build| build.status == 'success' && build.job_name == settings[:circleci_job_name] }
          .sort { |a, b| a.build_number <=> b.build_number }

      if successful_for_job.empty?
        STDERR.puts 'No successful builds for this branch and job name'
        exit 1
      end

      build_artifacts = successful_for_job.last.artifacts

      deploy_artifact = build_artifacts.find { |artifact| artifact.filename == settings[:circleci_artifact] }
      api_token = CircleCI::Client.instance.api_token
      curl = CurlCommand.new deploy_artifact.url, settings[:circleci_artifact], api_token
      curl.to_s
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
