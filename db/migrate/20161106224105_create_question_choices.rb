class CreateQuestionChoices < ActiveRecord::Migration[5.0]
  def change
    create_table :question_choices do |t|
      t.integer :question_id
      t.string :name

      t.timestamps
    end
  end
end
