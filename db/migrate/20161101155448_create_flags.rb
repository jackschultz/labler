class CreateFlags < ActiveRecord::Migration[5.0]
  def change
    create_table :flags do |t|
      t.integer :flaggable_id
      t.string :flaggable_type
      t.text :reasoning
      t.integer :user_id

      t.timestamps
    end
  end
end
