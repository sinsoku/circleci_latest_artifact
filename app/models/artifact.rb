class Artifact
  include ActiveModel::Model

  attr_accessor :username, :project, :branch, :filename, :format, :circle_token

  def project_url
    "https://circleci.com/api/v1/project/#{username}/#{project}"
  end

  def single_build_url
    with_token "#{project_url}/tree/#{branch}"
  end

  def artifacts_of_a_build_url
    with_token "#{project_url}/#{build_num}/artifacts"
  end

  def build_num
    get_json(single_build_url)[0]['build_num']
  end

  def artifact_urls
    get_json(artifacts_of_a_build_url).map { |x| x['url'] }
  end

  def latest_url
    path = format.nil? ? filename : "#{filename}.#{format}"
    artifact_urls.find { |url| url =~ /#{path}/ }
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
end
