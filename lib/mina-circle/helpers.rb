require 'uri'
module MinaCircle
  module Helpers
    def artifact_url
      options = settings.select { |k,v|
        k.to_s.start_with? artifact_source.to_s.downcase or
          options_whitelist.include? k
      }
      Module.const_get(artifact_source.to_s).artifact_url(options)
    rescue RuntimeError => e
      puts "Unable to determine url for deployment artifact"
      puts e.message
    end

    def options_whitelist
      [
        :branch
      ]
    end
  end
end
