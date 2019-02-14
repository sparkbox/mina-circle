require './test/helper'
require 'base64'

class TestCurlCommand < Minitest::Test
  def test_follow_redirects
    command = CurlCommand.new 'http://example.com/artifact.tar.gz', 'artifact.tar.gz', 'api_key'
    expected = "curl -L -o artifact.tar.gz http://example.com/artifact.tar.gz?circle-token=api_key"
    assert_equal expected, command.to_s
  end
end
