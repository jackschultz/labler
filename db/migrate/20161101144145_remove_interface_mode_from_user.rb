class RemoveInterfaceModeFromUser < ActiveRecord::Migration[5.0]
  def change
    if column_exists? :users, :input_mode
      remove_column :users, :input_mode
    end
  end
end
