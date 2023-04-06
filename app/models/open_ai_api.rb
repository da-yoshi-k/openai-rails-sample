class OpenAiApi
  require 'ruby/openai'

  def self.generate_suggestions(keyword = '')
    client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
    prompt_content = 'アイスブレークに合っている質問を最大5個まで提供してください。「・」、「- 」、連番は回答内に不要です。日本語で回答してください。改行区切りで質問文を5個並べてください。生成できない場合はエラーである旨を返してください。'
    keyword_content = "キーワード「#{keyword}」に関連する。"
    keyword_description = '質問文中にキーワードを含めるのは5個中の3個までとして、そのほか2つは遠くないけどキーワードが直接入らない質問を生成してください。'
    prompt_content = keyword_content + prompt_content if keyword.present?
    prompt_content += keyword_description if keyword.present?
    response = client.chat(
      parameters: {
        model: 'gpt-3.5-turbo',
        messages: [{ role: 'user', content: prompt_content }],
      }
    )
    suggestions = response.dig('choices', 0, 'message', 'content').split("\n")
    # 配列要素先頭の「・」「- 」「1. 」といった記号を削除
    suggestions.map! { |suggestion| suggestion.gsub(/・|- |\d+\. /, '') }
  end
end
