module ApplicationHelper
  def default_meta_tags
    {
      site: 'AIトークデッキ',
      title: 'AIトークデッキ',
      description: 'AIがキーワードから会話の話題を生成するサービスです。',
      keywords: 'AI,話題,キーワード',
      canonical: 'https://ai-talk-deck.fly.dev/',
      noindex: !Rails.env.production?,
      og: {
        site_name: 'AIトークデッキ',
        title: 'AIトークデッキ',
        description: 'AIがキーワードから会話の話題を生成するサービスです。',
        type: 'website',
        url: 'https://ai-talk-deck.fly.dev/',
        image: 'https://ai-talk-deck.fly.dev/ogp.png',
        locale: 'ja_JP'
      },
      twitter: {
        card: 'summary_large_image'
      }
    }
  end
end
