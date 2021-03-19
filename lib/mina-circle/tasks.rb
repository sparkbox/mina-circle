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

  def required_settings
    [ 
      :circleci_artifact,
      :circleci_user,
      :circleci_project,
      :circleci_job_name,
      :circleci_explode_command,
      :branch,
    ]
  end

  def ensure_and_fetch!(setting_name)
    ensure!(setting_name)
    fetch(setting_name)
    end

  required_settings.each do |required_setting|
    define_method required_setting do
      ensure_and_fetch! required_setting
    end
  end

  desc 'Downloads and explodes the archive file containing the build'
  task :deploy do
    required_settings.each &method(:ensure!)

    options = {
      circleci_user: circleci_user,
      circleci_project: circleci_project,
      branch: branch,
      circleci_job_name: circleci_job_name,
      circleci_artifact: circleci_artifact,
    }

    comment "[mina-circle] Fetching: #{circleci_artifact}"
    command artifact_fetch_command(options)

    command "#{circleci_explode_command} #{circleci_artifact}"

    command "rm #{circleci_artifact}"
  end
end
