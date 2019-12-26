class CreateLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :links do |t|
      t.string :title
      t.string :url
      t.text :description
      t.belongs_to :user, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
