class CreateScoreBets < ActiveRecord::Migration[5.2]
  def change
    create_table :score_bets do |t|
      t.references :user, index: true, foreign_key: true
      t.references :match, index: true, foreign_key: true
      t.references :team, index: true, foreign_key: true
      t.float :price
      t.integer :status

      t.timestamps
    end
  end
end
