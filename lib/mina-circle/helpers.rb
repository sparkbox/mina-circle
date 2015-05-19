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
      build_num = JSON.parse(open(url).read).first['build_num'].to_s
      puts "[mina-circle] Using build number: #{build_num}"
      puts "[mina-circle] Using username/project: #{circle_user}/#{circle_project}"
      build_num
    end

    def build_url
      "https://circle-artifacts.com/gh/#{circle_user}/#{circle_project}/#{latest_build_number}/artifacts/0/home/ubuntu/#{circle_artifact}?circle-token=#{circle_token}"
    end
  end
end

