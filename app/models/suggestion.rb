class Suggestion < ApplicationRecord
  belongs_to :topic
  validates :content, presence: true, length: { maximum: 255 }
end
