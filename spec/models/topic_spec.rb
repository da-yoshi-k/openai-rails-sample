require 'rails_helper'

RSpec.describe Topic, type: :model do
  describe 'validation' do
    context 'keyword' do
      it 'is valid when keyword is blank' do
        topic = build(:topic, keyword: '')
        expect(topic).to be_valid
      end

      it 'is valid when keyword is 10 characters' do
        topic = build(:topic, keyword: 'a' * 10)
        expect(topic).to be_valid
      end

      it 'is invalid when keyword is 11 characters' do
        topic = build(:topic, keyword: 'a' * 11)
        expect(topic).to be_invalid
      end
    end
  end
end
