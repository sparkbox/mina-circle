require 'rake/testtask'

Rake::TestTask.new do |t|
    t.pattern = 'test/**/*.rb'
end

task :gem do
  system('mkdir -p build')
  system('gem build mina-circle.gemspec')
  system('mv *.gem build/')
end
