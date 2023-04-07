class Topic < ApplicationRecord
  validates :keyword, allow_blank: true, length: { maximum: 10 }

  has_many :suggestions, dependent: :destroy
end
