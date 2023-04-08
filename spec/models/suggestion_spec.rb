require 'rails_helper'

RSpec.describe Suggestion, type: :model do
  describe 'validation' do
    context 'content' do
      it 'is invalid when content is blank' do
        suggestion = build(:suggestion, content: '')
        expect(suggestion).to be_invalid
      end

      it 'is valid when content is 255 characters' do
        suggestion = build(:suggestion, content: 'a' * 255)
        expect(suggestion).to be_valid
      end

      it 'is invalid when content is 256 characters' do
        suggestion = build(:suggestion, content: 'a' * 256)
        expect(suggestion).to be_invalid
      end
    end
  end
end
