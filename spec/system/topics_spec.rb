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

    it 'トップに戻るボタンを押した時に一覧ページからトップページに遷移すること' do
      visit root_path
      click_link '今まで生成された話題はこちら'
      expect(page).to have_content '今まで生成された話題'
      click_link 'トップに戻る', match: :first
      expect(page).to have_content 'AIトークデッキ'
    end
  end

  context 'ページネーションの検証' do
    let!(:topics) { create_list(:topic_with_suggestions, 25) }

    it '一覧ページにアクセスした時にページネーションが表示され、3ページまであること' do
      visit topics_path
      expect(page).to have_css '.pagination'
      expect(page).to have_link '2', href: '/topics?page=2'
      expect(page).to have_link '3', href: '/topics?page=3'
      expect(page).not_to have_link '4', href: '/topics?page=4'
    end

    # 作成とは逆順に表示されることに注意
    it '一覧ページにアクセスした時に1ページ目の話題が表示される' do
      visit topics_path
      topics.last(12).each do |topic|
        expect(page).to have_content topic.keyword
        expect(page).to have_content topic.suggestions.first.content
      end
      expect(page).not_to have_content topics.first.keyword
      expect(page).not_to have_content topics.first.suggestions.first.content
    end

    it '2ページ目にアクセスした時に2ページ目の話題が表示される' do
      visit topics_path
      click_link '2', match: :first
      expect(page).not_to have_content topics.last(12).last.keyword
      expect(page).not_to have_content topics.last(12).last.suggestions.first.content
      expect(page).not_to have_content topics.first.keyword
      expect(page).not_to have_content topics.first.suggestions.first.content
    end
  end
end
