require 'rails_helper'

# APIの実行はモデルのテストでは実施しない
RSpec.describe OpenAiApi, type: :model do
  describe 'generate_suggestions' do
    it 'returns an array of suggestions' do
      # モックの作成
      client = double('client')
      response = double('response')
      # モックの設定
      allow(OpenAI::Client).to receive(:new).and_return(client)
      allow(client).to receive(:chat).and_return(response)
      allow(response).to receive(:dig).and_return("・質問1\n・質問2\n・質問3\n・質問4\n・質問5")
      # テスト実行
      suggestions = OpenAiApi.generate_suggestions('キーワード')
      # テスト結果の検証
      expect(suggestions).to eq %w[質問1 質問2 質問3 質問4 質問5]
    end
  end

  describe 'build_prompt_for_suggestion' do
    it 'returns a prompt for suggestions' do
      prompt = OpenAiApi.build_prompt_for_suggestion('キーワード')
      expect(prompt).to eq 'キーワード「キーワード」に関連する、アイスブレークにピッタリな面白い質問を最大5個まで生成してください。「・」、「- 」、連番は回答内に不要です。日本語で回答してください。質問文を改行区切りで5つ出力してください。生成できない場合はエラーである旨を返してください。キーワードを含めた適切な質問を最大3つ、他の2つはキーワードを直接含まず違う角度から関連性を考えた質問を生成してください。'
    end

    it 'returns a prompt without keyword' do
      prompt = OpenAiApi.build_prompt_for_suggestion('')
      expect(prompt).to eq 'アイスブレークにピッタリな面白い質問を最大5個まで生成してください。「・」、「- 」、連番は回答内に不要です。日本語で回答してください。質問文を改行区切りで5つ出力してください。生成できない場合はエラーである旨を返してください。'
    end
  end

  describe 'clean_suggestions' do
    it 'returns an array of suggestions without symbols' do
      suggestions = OpenAiApi.clean_suggestions(['・質問1', '- 質問2', '1. 質問3', '質問4', '質問5'])
      expect(suggestions).to eq %w[質問1 質問2 質問3 質問4 質問5]
    end
  end
end
