require 'rubygems'
require 'json'
require 'open-uri'
require 'optparse'

project = "wonderfulmachine"
username = "sparkbox"
artifact = "wm.tar.gz"

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: deploy.rb [options]"

  options[:environment] = "staging"
  opts.on("-e", "--environment ENV", "Set environment") do |e|
    options[:environment] = e
  end

  options[:token] = false
  opts.on("-t", "--token CIRCLE-TOKEN", "Set circle-token") do |t|
    options[:token] = t
  end

end.parse!

token = options[:token] || raise('no token')
env = options[:environment] || raise('no env')

url = "https://circleci.com/api/v1/project/#{username}/#{project}?circle-token=#{token}&limit=1&filter=completed"
resp = JSON.parse(open(url).read)
num = resp.first['build_num']

puts "Deployment on the #{env} environment with build #{num}"

system("mina deploy on=#{env} build=#{num} token=#{token} project=#{project} username=#{username} artifact=#{artifact}")
