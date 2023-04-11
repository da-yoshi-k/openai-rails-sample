require 'rails_helper'

RSpec.describe 'Topics', type: :system do
  # 正常系のテスト
  context '話題生成の検証' do
    it 'キーワードが空欄の時話題の生成が行える' do
      visit new_topic_path
      fill_in 'topic_keyword', with: ''
      click_button '生成'
      expect(page).to have_content 'AIが生成した話題'
      expect(page).to have_content 'キーワード：なし'
    end

    it 'キーワードが入力されている時話題の生成が行える' do
      visit new_topic_path
      fill_in 'topic_keyword', with: 'テスト'
      click_button '生成'
      expect(page).to have_content 'AIが生成した話題'
      expect(page).to have_content 'キーワード：テスト'
    end
  end

  context '話題の一覧表示の検証' do
    let!(:topics) { create_list(:topic_with_suggestions, 3) }

    it '今まで生成された話題ページにアクセスした時に話題の一覧が表示される' do
      visit topics_path
      expect(page).to have_content '今まで生成された話題'
      topics.each do |topic|
        expect(page).to have_content topic.keyword
        expect(page).to have_content topic.suggestions.first.content
      end
    end
  end

  context '画面遷移の検証' do
    let!(:topic) { create(:topic_with_suggestions) }

    it 'トップに戻るボタンを押した時に詳細ページからトップページに遷移すること' do
      visit topic_path(topic)
      click_link 'トップに戻る'
      expect(page).to have_content 'AIトークデッキ'
    end

    fit 'トップに戻るボタンを押した時に一覧ページからトップページに遷移すること' do
      visit root_path
      click_link '今まで生成された話題はこちら'
      expect(page).to have_content '今まで生成された話題'
      click_link 'トップに戻る', match: :first
      expect(page).to have_content 'AIトークデッキ'
    end
  end
end
