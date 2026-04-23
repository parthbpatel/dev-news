class Vote < ApplicationRecord
  UP = 1
  DOWN = -1
  VALUES = [UP, DOWN].freeze

  belongs_to :user
  belongs_to :link

  validates :user_id, uniqueness: { scope: :link_id }
  validates :value, inclusion: { in: VALUES }

  scope :upvotes, -> { where(value: UP) }
  scope :downvotes, -> { where(value: DOWN) }

  def upvote?
    value == UP
  end

  def downvote?
    value == DOWN
  end
end
