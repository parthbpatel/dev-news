module Votes
  class Toggle
    def self.call(user:, link:, value:)
      new(user: user, link: link, value: value).call
    end

    def initialize(user:, link:, value:)
      @user = user
      @link = link
      @value = value
    end

    def call
      ActiveRecord::Base.transaction do
        vote = Vote.lock.find_or_initialize_by(user: user, link: link)

        if vote.persisted? && vote.value == value
          vote.destroy!
        else
          vote.value = value
          vote.save!
        end

        link.reload.refresh_ranking!
      end

      link
    end

    private

    attr_reader :link, :user, :value
  end
end
