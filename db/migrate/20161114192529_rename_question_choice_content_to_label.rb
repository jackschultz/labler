class RenameQuestionChoiceContentToLabel < ActiveRecord::Migration[5.0]
  def change
    rename_column :question_choices, :name, :label
    add_column :question_choices, :short_label, :string
  end
end
