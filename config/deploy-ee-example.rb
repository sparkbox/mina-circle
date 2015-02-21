require 'mina/bundler'
require 'mina/rails'
require 'YAML'

set :term_mode, 'system'
set :ssh_options, '-A'

set :env_config, YAML.load_file('./config/env.yml')
set :circle_token, ENV['token'] || raise('token required')
set :project, ENV['project'] || raise('project required')
set :artifact, ENV['artifact'] || raise('artifact name required')
set :username, ENV['username'] || raise('username required')
set :build, ENV['build'] || raise('build number required')
set :environment, ENV['on'] || env_config.fetch('default')

def timestamp
  Time.now().strftime("%Y-%m-%d_%H%M")
end

is_production = false
is_test = false

circle_url = "https://circle-artifacts.com/gh/#{ENV['username']}/#{ENV['project']}/"
artifacts_path = "/#{ENV['build']}/artifacts/0/home/ubuntu/#{ENV['artifact']}?circle-token=#{ENV['token']}"
temp_archive = "#{ENV['project']}_#{ENV['build']}.tar.gz"

puts "-----> Connecting to server, this may take a minute."

set :tag, "#{environment}_#{timestamp}"

task :environment do
  env_config.fetch(environment).each do |key, value|
    set key.to_sym, value.to_s
    if key == "is_production" and value
      is_production = true
    end
    if key == "is_test" and value
      is_test = true
    end
  end
end

set :shared_paths, ['uploads']

task :environment do

end

task :setup => :environment do
  queue  %[echo "-----> Get artifact: #{ENV['artifact']}"]
  url = circle_url + artifacts_path
  queue  %[echo "-----> URL: #{url}"]
  queue "curl -o #{temp_archive} #{url} && tar -zxf #{temp_archive}"
  queue "rm #{temp_archive}"
end

task :ee_setup => :environment do
  queue  %[echo "-----> Setup EE"]
  queue "mkdir system/expressionengine/cache"
  queue "rm system/expressionengine/config/database.php"
  queue "cp system/expressionengine/config/database.#{ENV['on']}.php 'system/expressionengine/config/database.php'"
  queue "chmod -R 777 system/expressionengine/cache"
  queue "chmod 666 system/expressionengine/config/config.php"
  queue "chmod 666 system/expressionengine/config/database.php"
  queue "rm -rf images/resized"
  queue %[echo "-----> #{deploy_to}/#{shared_path}/images/blog images/blog"]
  queue "ln -s #{deploy_to}/#{shared_path}/images/blog images/blog"
  queue "ln -s #{deploy_to}/#{shared_path}/images/uploads images/uploads"
  queue "ln -s #{deploy_to}/#{shared_path}/images/resized images/resized"
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :setup
    invoke :ee_setup
    invoke :'deploy:link_shared_paths'
    invoke :'deploy:cleanup'
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

