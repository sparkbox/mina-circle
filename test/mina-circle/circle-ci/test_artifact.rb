require './test/helper'

class TestProject < Minitest::Test
  def test_valid_url
    artifact = CircleCI::Artifact.new({'path' => 'a/path', 'url' => 'http://example.com'})
    assert artifact.contains_valid_url?
  end

  def test_invalid_url
    artifact = CircleCI::Artifact.new({'path' => 'a/path', 'url' => 'nope://example.com'})
    refute artifact.contains_valid_url?

    def test_no_url
      artifact = CircleCI::Artifact.new({'path' => 'a/path'})
      refute artifact.contains_valid_url?
    end
  end
end
