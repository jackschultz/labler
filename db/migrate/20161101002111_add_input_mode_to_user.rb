class AddInputModeToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :input_mode, :integer
  end
end
