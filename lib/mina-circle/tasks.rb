extend MinaCircle::Helpers
# # Mina CircleCI Build Artifact Deployment
# Deploy builds from CircleCI's artifact library.
#
#     require 'mina-circle'
#
# ## Settings
#
# ### circleci_user
# user name
#
# ### circleci_project
# Name by which CircleCI knows your project
#
# ### circleci_artifact
# Name CircleCI calls your build archive
#
# ### circleci_explode_command
# Command with options for decompressing the artifact archive

set :artifact_source, :CircleCI

namespace :mina_circle do
  desc 'Downloads and explodes the archive file containing the build'
  task :deploy do
    puts "[mina-circle] Fetching: #{circleci_artifact}"
    queue echo_cmd("curl -o #{circleci_artifact} #{artifact_url}")
    queue echo_cmd("#{circleci_explode_command} #{circleci_artifact}")
    queue echo_cmd("rm #{circleci_artifact}")
  end
end
