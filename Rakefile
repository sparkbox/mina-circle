require 'rake/testtask'
require './lib/mina-circle/version'

Rake::TestTask.new do |t|
    t.pattern = 'test/**/test_*.rb'
end

namespace :gem do

  task :build do
    system('mkdir -p build')
    system('gem build mina-circle.gemspec')
    system('mv *.gem build/')
  end

  task :upload => :build do
    gem_file = "build/mina-circle-#{MinaCircle::VERSION}.gem"
    system "gem push #{gem_file}"
  end

end
