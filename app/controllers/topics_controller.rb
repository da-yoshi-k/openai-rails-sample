class TopicsController < ApplicationController
  def index; end

  def new
    @topic = Topic.new
  end

  def show
    @topic = Topic.find(params[:id])
    @suggestions = @topic.suggestions
  end

  def create
    @topic = Topic.new(topic_params)
    if @topic.save
      @suggestions = OpenAiApi.generate_suggestions(@topic.keyword)
      @suggestions.each do |suggestion|
        @topic.suggestions.create(content: suggestion)
      end
      redirect_to @topic
    else
      render :new
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:keyword)
  end
end
