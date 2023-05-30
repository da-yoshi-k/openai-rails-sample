class OpenAiApi
  require 'ruby/openai'

  def self.generate_suggestions(keyword = '')
    # キーワードが入力されており、ネガティブなワードが含まれている場合はNGであると判定
    if keyword.present? && validate_negative_keyword(keyword)
      Rails.logger.error("inappropriate keyword: #{keyword}")
      return 'NG'
    end

    client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
    prompt_content = build_prompt_for_suggestion(keyword)
    response = client.chat(
      parameters: {
        model: 'gpt-3.5-turbo',
        messages: [{ role: 'user', content: prompt_content }]
      }
    )
    res_suggestions = response.dig('choices', 0, 'message', 'content')
    if res_suggestions.blank?
      Rails.logger.error("res_suggestions: #{res_suggestions}")
      return ''
    end

    suggestions = res_suggestions.split("\n")
    result = clean_suggestions(suggestions)
    Rails.logger.error("suggestions: #{suggestions}") if result.blank?
    result
  end

  def self.build_prompt_for_suggestion(keyword)
    keyword_content = if keyword.present?
                        "#{keyword}というキーワードに関連する、"
                      else
                        ''
                      end
    keyword_description = if keyword.present?
                            '質問中にキーワードを直接含めた質問は5個中の3つまでとし、残りの2つはキーワードを直接含まず違う角度から関連性を考えた質問にしてください。'
                          else
                            ''
                          end
    "#{keyword_content}アイスブレークにピッタリな面白い質問を5個日本語で生成してください。#{keyword_description}あなたは参加者の会話を引き出すプロのファシリテーターであるかのように質問を考えてください。次のフォーマットに準拠し、'{質問}'の箇所を生成した質問を置換してください。質問中には「？」を含めてください。フォーマット：'・{質問}\n・{質問}\n・{質問}\n・{質問}\n・{質問}'"
  end

  # 配列要素先頭の「・」「- 」「1. 」といった記号を削除
  # 「?」「？」を含まない要素を削除
  def self.clean_suggestions(suggestions)
    suggestions.map! { |suggestion| suggestion.gsub(/・|- |\d+\. /, '') }
    suggestions.select { |suggestion| suggestion.include?('?') || suggestion.include?('？') }
  end

  # Natural Language APIを利用して不適切なワードが含まれているか判定
  def self.validate_negative_keyword(keyword)
    Google::Cloud::Language.configure do |config|
      encoded_json = ENV['GOOGLE_APPLICATION_CREDENTIALS_BASE64']
      json = Base64.decode64(encoded_json)
      config.credentials = JSON.parse(json)
    end
    client = Google::Cloud::Language.language_service(version: :v1)
    document = { content: keyword, type: :PLAIN_TEXT, language: 'ja' }
    v2_model_options = {
      v2_model: {
        content_categories_version: :V2
      }
    }
    response = client.classify_text(document:, classification_model_options: v2_model_options)
    # 本番環境以外ではresponseをログ出力する
    Rails.logger.debug("response: #{response}") unless Rails.env.production?
    # /Adult, /Sensitive Subjects が含まれている場合はネガティブなキーワードと判定
    response.categories.map(&:name).any? { |category| category.include?('/Adult') || category.include?('/Sensitive Subjects') }
  end
end
