class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :link

  validates :body, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :for_display, -> { includes(:user).recent }
end
