class QuestionChoice < ApplicationRecord

  belongs_to :question
  has_many :answer_choices

end
