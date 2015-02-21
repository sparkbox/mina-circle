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

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :setup
    invoke :'deploy:link_shared_paths'
    invoke :'deploy:cleanup'
  end
end
