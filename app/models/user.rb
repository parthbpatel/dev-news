class User < ApplicationRecord
  has_secure_password

  before_validation :normalize_username

  has_many :links, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy

  validates :username,
            presence: true,
            length: { minimum: 3 },
            uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 8 }, allow_nil: true

  def self.find_by_normalized_username(username)
    normalized_username = normalize_username_value(username)
    return if normalized_username.blank?

    find_by('LOWER(username) = ?', normalized_username)
  end

  def owns_link?(link)
    link.present? && self == link.user
  end

  def owns_comment?(comment)
    comment.present? && self == comment.user
  end

  def upvoted?(link)
    vote_for(link)&.upvote?
  end

  def downvoted?(link)
    vote_for(link)&.downvote?
  end

  private

  def vote_for(link)
    votes.find_by(link: link)
  end

  def normalize_username
    self.username = self.class.normalize_username_value(username)
  end

  def self.normalize_username_value(username)
    username.to_s.strip.downcase.presence
  end
end
