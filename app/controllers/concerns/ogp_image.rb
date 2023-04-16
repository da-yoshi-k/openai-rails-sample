module OgpImage
  extend ActiveSupport::Concern

  def build_image(suggestion)
    text = prepare_text(suggestion[:content], suggestion.topic[:keyword])
    image = MiniMagick::Image.open('./app/assets/images/frame.png')
    font_medium = './app/assets/fonts/NotoSansJP-Medium.ttf'
    image.combine_options do |c|
      c.font font_medium
      c.gravity 'center'
      c.pointsize 36
      c.draw "text 0,0 '#{text}'"
    end
    image.format 'png'
  end

  private

  def prepare_text(text, keyword)
    question = text.to_s.scan(/.{1,26}/)[0...6].join("\n")
    question += "\n生成元キーワード：#{keyword}" if keyword.present?
    question
  end
end
