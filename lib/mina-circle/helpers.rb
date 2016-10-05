module MinaCircle
  module Helpers
    def artifact_url
      Module.const_get(artifact_source.to_s).artifact_url
    end
  end
end
