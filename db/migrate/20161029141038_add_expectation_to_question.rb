class AddExpectationToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :expectation, :integer
  end
end
