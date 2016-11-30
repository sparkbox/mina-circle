require './test/helper'

class TestProject < Minitest::Test
  def test_api_path
    project = CircleCI::Project.new organization: 'foo', name: 'bar', branch: 'master'
    assert_equal 'github/foo/bar', project.api_path
  end
end
