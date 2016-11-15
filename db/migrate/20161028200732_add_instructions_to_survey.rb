class AddInstructionsToSurvey < ActiveRecord::Migration[5.0]
  def change
    add_column :surveys, :instructions, :text
  end
end
