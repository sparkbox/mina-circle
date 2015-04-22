extend MinaCircle::Helpers
# # Mina CircleCI Build Artifact Deployment
# Deploy builds from CircleCI's artifact library.
#
#     require 'mina-circle'
#
# ## Settings
#
# ### circle_token
# API access token. By default this is taken from ~/.mina-circle.yml if it exists
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

set_default(:circle_token, parse_from_home_dir || fail('CircleCI token required'))

namespace :circleci do

  desc 'Downloads and explodes the archive file containing the build'
  task :deploy do
    queue "curl -o #{circle_artifact} #{build_url}"
    queue "#{circle_explode_command} #{circle_artifact}"
  end
end
