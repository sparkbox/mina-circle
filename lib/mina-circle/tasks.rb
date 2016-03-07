extend MinaCircle::Helpers
# # Mina CircleCI Build Artifact Deployment
# Deploy builds from CircleCI's artifact library.
#
#     require 'mina-circle'
#
# ## Settings
#
# ### circle_user
# user name
#
# ### circle_project
# Name by which CircleCI knows your project
#
# ### circle_artifact
# Name CircleCI calls your build archive
#
# ### circle_explode_command
# Command with options for decompressing the artifact archive

namespace :circleci do

  desc 'Downloads and explodes the archive file containing the build'
  task :deploy do
    if circle_ci.artifact_present?
      puts "[mina-circle] Fetching: #{circle_artifact}"
      queue "curl -o #{circle_artifact} #{circle_ci.latest_artifact.url}"
      queue "#{circle_explode_command} #{circle_artifact}"
      queue "rm #{circle_artifact}"
    else
      puts "No artifacts found for the latest build of #{branch}"
    end
  end
end
