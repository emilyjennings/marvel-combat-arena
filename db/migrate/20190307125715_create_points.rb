class CreatePoints < ActiveRecord::Migration[5.2]
  def change
    create_table :points do |t|
      t.integer :points
      t.integer :user_id
      t.timestamps
    end
  end
end
