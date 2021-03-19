require 'mina/deploy'
require 'mina-circle'

# require 'mina/rbenv'  # for rbenv support. (https://rbenv.org)
# require 'mina/rvm'    # for rvm support. (https://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :application_name, 'foobar'
set :domain, '23.253.162.16'
set :user, 'sparkuser'
set :repository, 'https://github.com/sparkbox/tirediscounters.git'
set :deploy_to, '/var/www/vhosts/foobar.com'
set :branch, 'main'

set :circleci_user, 'sparkbox'
set :circleci_project, 'tirediscounters'#example-circle-project'
set :circleci_job_name, 'create_sparkboxqa_artifact'#`default-job'
set :circleci_artifact, 'tirediscounters-dist-docker.tar.gz'#example-dist.tar.gz'
set :circleci_explode_command, 'tar -mzxf'

# Optional settings:
#   set :user, 'foobar'          # Username in the server to SSH to.
#   set :port, '30000'           # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# Shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# Some plugins already add folders to shared_dirs like `mina/rails` add `public/assets`, `vendor/bundle` and many more
# run `mina -d` to see all folders and files already included in `shared_dirs` and `shared_files`
# set :shared_dirs, fetch(:shared_dirs, []).push('public/assets')
# set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml')


desc "Deploys the current version to the server."
task :deploy do
  run(:local){ invoke :'mina_circle:deploy' }
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
