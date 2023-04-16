class SuggestionsController < ApplicationController
  layout 'share_card', only: :show
  include OgpImage

  def show
    @suggestion = Suggestion.find(params[:id])
  end

  def image
    @suggestion = Suggestion.find(params[:id])
    image = build_image(@suggestion)
    send_data image.to_blob, type: 'image/png', disposition: 'inline'
  end
end
