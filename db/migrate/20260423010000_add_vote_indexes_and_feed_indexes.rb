class AddVoteIndexesAndFeedIndexes < ActiveRecord::Migration[6.0]
  def change
    add_index :votes, %i[user_id link_id], unique: true
    add_index :links, :hot_score
    add_index :links, :created_at
    add_index :comments, :created_at
  end
end
