require './test/helper'

class TestProject < Minitest::Test
  def test_api_path
    project = CircleCI::Project.new organization: 'foo', name: 'bar', branch: 'master'
    assert_equal 'project/github/foo/bar', project.api_path
  end

  def test_build_path
    project = CircleCI::Project.new organization: 'foo', name: 'bar', branch: 'master'
    assert_equal 'project/github/foo/bar/tree/master', project.build_path
  end
end
