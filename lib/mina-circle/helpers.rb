module MinaCircle
  module Helpers
    def parse_from_home_dir
      File.exist?(config_file) ? YAML.load_file(config_file)['token'] : nil
    end

    def config_file
      File.join(Dir.home, '.mina-circle.yml')
    end

    def latest_build_number
      base_uri = 'https://circleci.com/api/v1/project'
      base_path = "#{circle_user}/#{circle_project}/tree/master"
      url = "#{base_uri}/#{base_path}?circle-token=#{circle_token}&limit=1&filter=completed"
      JSON.parse(open(url).read).first['build_num'].to_s
    end

    def build_url
      "https://circle-artifacts.com/gh/#{circle_user}/#{circle_project}/#{latest_build_number}/artifacts/0/home/ubuntu/#{circle_artifact}?circle-token=#{circle_token}"
    end
  end
end
