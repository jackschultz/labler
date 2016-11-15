class CreateAnswerChoices < ActiveRecord::Migration[5.0]
  def change
    create_table :answer_choices do |t|
      t.integer :answer_id
      t.integer :question_choice_id

      t.timestamps
    end
  end
end
