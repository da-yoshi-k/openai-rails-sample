require 'rails_helper'

RSpec.describe 'Topics', type: :system do
  # 正常系のテスト
  context 'キーワードが空欄の時' do
    it '話題の生成が行える' do
      visit new_topic_path
      fill_in 'topic_keyword', with: ''
      click_button '生成'
      expect(page).to have_content 'AIが生成した話題'
      expect(page).to have_content 'キーワード：なし'
    end
  end

  context 'キーワードが入力されている時' do
    it '話題の生成が行える' do
      visit new_topic_path
      fill_in 'topic_keyword', with: 'テスト'
      click_button '生成'
      expect(page).to have_content 'AIが生成した話題'
      expect(page).to have_content 'キーワード：テスト'
    end
  end

  context 'トップに戻るボタンを押した時' do
    let(:topic) { create(:topic_with_suggestions) }

    it '詳細ページからトップページに遷移すること' do
      visit topic_path(topic)
      click_link 'トップに戻る'
      expect(page).to have_content 'AIトークデッキ'
    end
  end
end
