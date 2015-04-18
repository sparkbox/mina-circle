require './lib/mina-circle/version'

Gem::Specification.new do |s|
  s.name = 'mina-circle'
  s.version = MinaCircle::VERSION
  s.summary = 'Deploy your application from artifacts produced by CircleCI'
  s.authors = ['Patrick Simpson', 'Michael Yockey']

  s.files = Dir.glob('lib/**/*')
  s.require_path = 'lib'

  s.add_runtime_dependency 'mina', '~> 0.3', '>= 0.3.0'
end
