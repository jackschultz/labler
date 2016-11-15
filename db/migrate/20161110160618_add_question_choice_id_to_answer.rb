class AddQuestionChoiceIdToAnswer < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :question_choice_id, :integer
  end
end
