require './test/helper'

class TestCircleCI < Minitest::Test

  attr_reader :artifact, :project
  def setup
    @artifact = CircleCI::Artifact.new({ 'path' => 'path/to/artifact.tar.gz', 'url' => 'http://example.com/artifact.tar.gz' })
    @project = CircleCI::Project.new organization: 'foo', name: 'bar', branch: 'master'
  end

  def test_artifact_url
    CircleCI.circle_artifact = 'artifact.tar.gz'
    project.artifacts = [ artifact ]
    CircleCI.project = project
    assert_equal 'http://example.com/artifact.tar.gz', CircleCI.artifact_url
  end

  def test_invalid_artifact_url
    CircleCI.circle_artifact = 'artifact.tar.gz'
    artifact = CircleCI::Artifact.new({ 'path' => 'path/to/artifact.tar.gz', 'url' => 'invalid' })
    project.artifacts = [ artifact ]
    CircleCI.project = project
    assert_raises do
      CircleCI.artifact_url
    end
  end
end
