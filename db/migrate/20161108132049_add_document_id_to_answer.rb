class AddDocumentIdToAnswer < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :document_id, :integer
    add_column :answers, :user_id, :integer
  end
end
