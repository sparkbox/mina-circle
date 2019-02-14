extend MinaCircle::Helpers
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

namespace :mina_circle do
  desc 'Downloads and explodes the archive file containing the build'
  task :deploy do

    if !circleci_artifact
      print_error "[mina-circle] You must specify a `circleci_artifact`"
      die
    end
    if !circleci_user
      print_error "[mina-circle] You must specify a `circleci_user`"
      die
    end
    if !circleci_project
      print_error "[mina-circle] You must specify a `circleci_project`"
      die
    end

    print_str "[mina-circle] Fetching: #{circleci_artifact}"
    queue echo_cmd(artifact_fetch_command)
    queue echo_cmd("#{circleci_explode_command} #{circleci_artifact}")
    queue echo_cmd("rm #{circleci_artifact}")
  end
end
