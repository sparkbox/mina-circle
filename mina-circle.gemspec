require './lib/mina-circle/version'

Gem::Specification.new do |s|
  s.name = 'mina-circle'
  s.version = MinaCircle::VERSION
  s.summary = 'Deploy your application from artifacts produced by CircleCI'
  s.authors = ['Patrick Simpson', 'Michael Yockey']
  s.email = ['patrick@heysparkbox.com', 'mike@heysparkbox.com']
  s.licenses = ['MIT']
  s.description = 'Deploy without dependancies using mina and CircleCI.'
  s.files = Dir.glob('lib/**/*')
  s.require_path = 'lib'
  s.homepage = 'https://github.com/sparkbox/mina-circle'

  s.add_runtime_dependency 'mina', '~> 0.3', '>= 0.3.0'
  s.add_development_dependency 'rake', '>= 12.3.3'
  s.add_development_dependency 'minitest', '>= 5.8.0'
end
