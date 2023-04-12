class TopicsController < ApplicationController
  def index
    @topics = Topic.includes(:suggestions).order(created_at: :desc).page(params[:page])
  end

  def new
    @topic = Topic.new
  end

  def show
    @topic = Topic.find(params[:id])
    @suggestions = @topic.suggestions
  end

  def create
    @topic = Topic.new(topic_params)
    @suggestions = OpenAiApi.generate_suggestions(@topic.keyword)
    if @suggestions.blank?
      flash[:error] = 'エラーが発生しました。再度お試しください。'
      redirect_to action: :new
    else
      return render :new unless @topic.save

      @suggestions.each do |suggestion|
        @topic.suggestions.create(content: suggestion)
      end
      redirect_to @topic
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:keyword)
  end
end
