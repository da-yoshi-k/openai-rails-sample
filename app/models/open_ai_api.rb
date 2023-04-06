class OpenAiApi
  require 'ruby/openai'

  def self.generate_suggestions(keyword = '')
    client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
    prompt_content = build_prompt_for_suggestion(keyword)
    response = client.chat(
      parameters: {
        model: 'gpt-3.5-turbo',
        messages: [{ role: 'user', content: prompt_content }],
      }
    )
    suggestions = response.dig('choices', 0, 'message', 'content').split("\n")
    clean_suggestions(suggestions)
  end

  def self.build_prompt_for_suggestion(keyword)
    prompt_content = 'アイスブレークにピッタリな面白い質問を最大5個まで生成してください。「・」、「- 」、連番は回答内に不要です。日本語で回答してください。質問文を改行区切りで5つ出力してください。生成できない場合はエラーである旨を返してください。'
    keyword_content = "キーワード「#{keyword}」に関連する、"
    keyword_description = 'キーワードを含めた適切な質問を最大3つ、他の2つはキーワードを直接含まず違う角度から関連性を考えた質問を生成してください。'
    prompt_content = keyword_content + prompt_content if keyword.present?
    prompt_content += keyword_description if keyword.present?
    prompt_content
  end

  # 配列要素先頭の「・」「- 」「1. 」といった記号を削除
  def self.clean_suggestions(suggestions)
    suggestions.map! { |suggestion| suggestion.gsub(/・|- |\d+\. /, '') }
  end
end
