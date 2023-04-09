require 'rails_helper'

# APIの実行はモデルのテストでは実施しない
# プロンプトの文字列生成は頻繁に変更が入る可能性があるため、テストは実施しない
RSpec.describe OpenAiApi, type: :model do
  describe 'generate_suggestions' do
    it 'returns an array of suggestions' do
      # モックの作成
      client = double('client')
      response = double('response')
      # モックの設定
      allow(OpenAI::Client).to receive(:new).and_return(client)
      allow(client).to receive(:chat).and_return(response)
      allow(response).to receive(:dig).and_return("・質問1？\n・質問2？\n・質問3？\n・質問4？\n・質問5？")
      # テスト実行
      suggestions = OpenAiApi.generate_suggestions('キーワード')
      # テスト結果の検証
      expect(suggestions).to eq %w[質問1？ 質問2？ 質問3？ 質問4？ 質問5？]
    end

    it 'returns nil when response is no answer' do
      client = double('client')
      response = double('response')
      allow(OpenAI::Client).to receive(:new).and_return(client)
      allow(client).to receive(:chat).and_return(response)
      allow(response).to receive(:dig).and_return('回答できません')

      suggestions = OpenAiApi.generate_suggestions('キーワード')
      expect(suggestions).to eq []
    end
  end

  describe 'clean_suggestions' do
    it 'returns an array of suggestions without symbols' do
      suggestions = OpenAiApi.clean_suggestions(['・質問1？', '- 質問2？', '1. 質問3？', '質問4？', '質問5？', '質問6'])
      expect(suggestions).to eq %w[質問1？ 質問2？ 質問3？ 質問4？ 質問5？]
    end
  end
end
