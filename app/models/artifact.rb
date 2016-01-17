class Artifact
  include ActiveModel::Model

  ATTRIBUTES = %i(username project branch filename circle_token).freeze
  attr_accessor(*ATTRIBUTES)

  def project_url
    "https://circleci.com/api/v1/project/#{username}/#{project}"
  end

  def artifact_urls
    nums = branch_builds.map { |x| x['build_num'] }
    json = artifacts(nums[0])
    json = artifacts(nums[1]) if json.blank?
    json.map { |x| x['url'] }
  end

  def latest_url
    artifact_urls.find { |url| url =~ /#{filename}/ }
  end

  private

  def with_token(url)
    circle_token.nil? ? url : "#{url}?circle-token=#{circle_token}"
  end

  def get_json(url)
    uri = URI.parse url
    res = Net::HTTP.get(uri)
    ActiveSupport::JSON.decode res
  end

  def branch_builds
    get_json with_token("#{project_url}/tree/#{branch}")
  end

  def artifacts(num)
    get_json with_token("#{project_url}/#{num}/artifacts")
  end
end
