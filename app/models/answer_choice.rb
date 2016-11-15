class AnswerChoice < ApplicationRecord

  belongs_to :answer
  belongs_to :question_choice

end
