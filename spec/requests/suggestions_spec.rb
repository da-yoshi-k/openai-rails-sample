require 'rails_helper'

RSpec.describe 'Suggestions', type: :request do
  let(:suggestion) { create(:suggestion) }

  describe 'GET #image' do
    let(:image) { MiniMagick::Image.read(response.body) }

    before do
      get image_suggestion_path(suggestion.id)
    end

    it '画像が生成されること' do
      expect(image).to be_an_instance_of(MiniMagick::Image)
    end

    it '画像のフォーマットがpngであること' do
      expect(image.type).to eq 'PNG'
    end

    it '画像のサイズが指定したサイズであること' do
      expect(image.width).to eq 1200
      expect(image.height).to eq 630
    end
  end
end
