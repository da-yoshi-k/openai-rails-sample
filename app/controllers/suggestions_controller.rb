class SuggestionsController < ApplicationController
  layout 'share_card', only: :show

  def show
    @suggestion = Suggestion.find(params[:id])
  end
end
