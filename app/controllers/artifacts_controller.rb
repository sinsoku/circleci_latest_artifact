class ArtifactsController < ApplicationController
  def show
    @artifact = Artifact.new(artifact_params)
    redirect_to @artifact.latest_url
  end

  private

  def artifact_params
    params.permit(*Artifact::ATTRIBUTES)
  end
end
