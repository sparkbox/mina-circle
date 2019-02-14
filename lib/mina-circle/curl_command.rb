class CurlCommand
  attr_reader :artifact_url, :output_file_name, :api_key, :follow_redirects
  def initialize(artifact_url, output_file_name, api_key, follow_redirects = true)
    @artifact_url = artifact_url
    @output_file_name = output_file_name
    @api_key = api_key
    @follow_redirects = follow_redirects
  end

  def follow_redirects?
    !!follow_redirects
  end

  def authenticated_artifact_url
    "#{artifact_url}?circle-token=#{api_key}"
  end
  
  def to_s
    "curl #{follow_redirects? ? '-L' : ''} -o #{output_file_name} #{authenticated_artifact_url}"
  end
end
