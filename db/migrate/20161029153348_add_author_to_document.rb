class AddAuthorToDocument < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :author, :string
  end
end
