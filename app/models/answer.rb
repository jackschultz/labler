class Answer < ApplicationRecord

  belongs_to :question
  belongs_to :user
  belongs_to :document
  belongs_to :question_choice

  has_many :answer_choices

end
