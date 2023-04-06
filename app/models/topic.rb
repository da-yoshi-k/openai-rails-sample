class Topic < ApplicationRecord
  validates :keyword, allow_blank: true, length: { maximum: 10 }
  validate :suggestion_size_validate

  has_many :suggestions, dependent: :destroy

  SUGGESTION_MAX = 5
  def suggestion_size_validate
    errors.add(:suggestions, 'suggestions over') if suggestions.size > SUGGESTION_MAX
  end
end
