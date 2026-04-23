class Link < ApplicationRecord
  HOT_SCORE_GRAVITY = 1.8

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy

  validates :title,
              presence: true,
              uniqueness: { case_sensitive: false }

  validates :url,
            format: { with: %r{\Ahttps?://} },
            allow_blank: true

  scope :for_feed, -> { includes(:user, :comments, :votes) }
  scope :for_show, -> { includes(:user, :votes) }
  scope :hottest, -> { order(hot_score: :desc, created_at: :desc) }
  scope :newest, -> { order(created_at: :desc) }

  def comment_count
    comments.size
  end

  def upvotes
    if association(:votes).loaded?
      votes.count(&:upvote?)
    else
      votes.upvotes.count
    end
  end

  def downvotes
    if association(:votes).loaded?
      votes.count(&:downvote?)
    else
      votes.downvotes.count
    end
  end

  def vote_total
    if association(:votes).loaded?
      votes.sum(&:value)
    else
      votes.sum(:value)
    end
  end

  def refresh_ranking!
    score_points = vote_total
    update!(points: score_points, hot_score: ranking_score(score_points))
  end

  private

  def ranking_score(points, gravity = HOT_SCORE_GRAVITY)
    return 0.0 if points.zero?

    points.to_f / (age_in_hours + 2) ** gravity
  end

  def age_in_hours
    ((Time.current - created_at) / 1.hour).round
  end
end
