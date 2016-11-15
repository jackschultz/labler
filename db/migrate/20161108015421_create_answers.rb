class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.timestamps

      t.integer  :question_id
      t.text     :string_value
      t.integer  :checkbox_value
      t.integer  :answer_id
      t.decimal  :decimal_value
      t.integer  :integer_value
      t.integer  :user_id
    end
  end
end
