require 'minitest/autorun'
require 'minitest/mock'
require './lib/mina-circle/circle_ci'
require_relative 'support/vcr'

class CircleCITest < MiniTest::Unit::TestCase
  def test_builds_returns_a_collection
    circle = CircleCI.new 'sparkbox', 'mina-circle'
    VCR.use_cassette('builds-mina-circle') do
      assert_kind_of(Enumerable, circle.builds)
    end
  end

  def test_builds_for_a_bad_project_returns_an_empty_collection
    circle = CircleCI.new 'sparkbox', 'this-project-does-not-exist'
    VCR.use_cassette('builds-no-project') do
      assert_equal(circle.builds, [])
    end
  end

  def test_artifacts_returns_a_collection
    circle = CircleCI.new 'sparkbox', 'mina-circle'
    build = Minitest::Mock.new.expect(:build_num, 6)
    VCR.use_cassette('artifacts-mina-circle') do
      artifacts = circle.artifacts(build)
      assert_kind_of(Enumerable, artifacts)
    end
  end

  def test_artifacts_for_a_bad_project_returns_an_empty_collection
    circle = CircleCI.new 'sparkbox', 'this-project-does-not-exist'
    build = Minitest::Mock.new.expect(:build_num, 6)
    VCR.use_cassette('artifacts-no-project') do
      assert_equal(circle.artifacts(build), [])
    end
  end

  def test_builds_public_projects_work_without_token
    circle = CircleCI.new 'sparkbox', 'mina-circle'
    VCR.use_cassette('builds-no-token') do
      CircleCI.stub(:token, nil) do
        assert_kind_of(Enumerable, circle.builds)
      end
    end
  end

  def test_artifacts_public_projects_work_without_token
    circle = CircleCI.new 'sparkbox', 'mina-circle'
    build = Minitest::Mock.new.expect(:build_num, 6)
    VCR.use_cassette('artifacts-no-token') do
      CircleCI.stub(:token, nil) do
        assert_kind_of(Enumerable, circle.artifacts(build))
      end
    end
  end

  def test_artifact_urls_can_include_circle_token
    circle = CircleCI.new 'sparkbox', 'mina-circle'
    build = Minitest::Mock.new.expect(:build_num, 6)
    VCR.use_cassette('artifacts-mina-circle') do
      CircleCI.stub(:token, 'token') do
        artifacts = circle.artifacts(build)
        assert(artifacts.first.url.end_with?('?circle-token=token'))
      end
    end
  end
end
