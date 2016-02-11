require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
  config.filter_sensitive_data('<CIRCLE_TOKEN>') { CircleCI.token }
end
