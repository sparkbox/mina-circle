module MinaCircle
  module Helpers
    def artifact_url
      Module.const_get(artifact_source.to_s).artifact_url
    rescue RuntimeError => e
      puts "Unable to determine url for deployment artifact"
      puts e.message
    end
  end
end
