class NormalizeVotes < ActiveRecord::Migration[6.0]
  def up
    add_column :votes, :value, :integer

    execute <<~SQL
      UPDATE votes
      SET value = CASE
                    WHEN upvote = 1 AND downvote = 0 THEN 1
                    WHEN upvote = 0 AND downvote = 1 THEN -1
                    ELSE 1
                  END
    SQL

    change_column_null :votes, :value, false

    execute <<~SQL
      ALTER TABLE votes
      ADD CONSTRAINT votes_value_check
      CHECK (value IN (-1, 1))
    SQL

    remove_column :votes, :upvote, :integer
    remove_column :votes, :downvote, :integer

    change_column_default :links, :points, from: 1, to: 0

    execute <<~SQL
      UPDATE links
      SET points = COALESCE(vote_totals.total_points, 0),
          hot_score = CASE
                        WHEN COALESCE(vote_totals.total_points, 0) = 0 THEN 0.0
                        ELSE COALESCE(vote_totals.total_points, 0)::float /
                             POWER((((EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - links.created_at)) / 3600)::integer) + 2), 1.8)
                      END
      FROM (
        SELECT link_id, SUM(value) AS total_points
        FROM votes
        GROUP BY link_id
      ) AS vote_totals
      WHERE links.id = vote_totals.link_id
    SQL

    execute <<~SQL
      UPDATE links
      SET points = 0, hot_score = 0.0
      WHERE id NOT IN (SELECT DISTINCT link_id FROM votes)
    SQL
  end

  def down
    add_column :votes, :upvote, :integer, default: 0, null: false
    add_column :votes, :downvote, :integer, default: 0, null: false

    execute <<~SQL
      UPDATE votes
      SET upvote = CASE WHEN value = 1 THEN 1 ELSE 0 END,
          downvote = CASE WHEN value = -1 THEN 1 ELSE 0 END
    SQL

    execute <<~SQL
      ALTER TABLE votes
      DROP CONSTRAINT IF EXISTS votes_value_check
    SQL

    remove_column :votes, :value, :integer

    change_column_default :links, :points, from: 0, to: 1

    execute <<~SQL
      UPDATE links
      SET points = COALESCE(vote_totals.upvotes, 0) - COALESCE(vote_totals.downvotes, 0),
          hot_score = CASE
                        WHEN (COALESCE(vote_totals.upvotes, 0) - COALESCE(vote_totals.downvotes, 0)) = 0 THEN 0.0
                        ELSE (COALESCE(vote_totals.upvotes, 0) - COALESCE(vote_totals.downvotes, 0) - 1)::float /
                             POWER((((EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - links.created_at)) / 3600)::integer) + 2), 1.8)
                      END
      FROM (
        SELECT link_id, SUM(upvote) AS upvotes, SUM(downvote) AS downvotes
        FROM votes
        GROUP BY link_id
      ) AS vote_totals
      WHERE links.id = vote_totals.link_id
    SQL

    execute <<~SQL
      UPDATE links
      SET points = 1, hot_score = 0.0
      WHERE id NOT IN (SELECT DISTINCT link_id FROM votes)
    SQL
  end
end
