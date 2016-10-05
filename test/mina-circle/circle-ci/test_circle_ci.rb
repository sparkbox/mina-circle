require './test/helper'

class TestCircleCI < Minitest::Test
  def artifact
    @artifact ||= CircleCI::Artifact.new({ 'path' => 'path/to/artifact.tar.gz', 'url' => 'http://example.com/artifact.tar.gz' })
  end

  def project
    @project ||= CircleCI::Project.new organization: 'foo', name: 'bar', branch: 'master'
  end

  def test_artifact_url
    CircleCI.circle_artifact = 'artifact.tar.gz'
    project.artifacts = [ artifact ]
    CircleCI.project = project
    assert_equal 'http://example.com/artifact.tar.gz', CircleCI.artifact_url
  end
end
