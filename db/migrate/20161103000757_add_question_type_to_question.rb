class AddQuestionTypeToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :question_type, :integer
    if column_exists? :questions, :expectation
      remove_column :questions, :expectation
    end
  end
end
