class AddSurveyIdToDocument < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :survey_id, :integer
  end
end
