class Question < ApplicationRecord
  belongs_to :survey

  has_many :answers
  has_many :users, through: :responses
  has_many :question_choices

  accepts_nested_attributes_for :question_choices

  enum question_type: [ :text, :integer, :decimal, :checkbox, :radio, :multi_value_number ]

  def max_answer_on_document_by_user(document, user)
    answers = self.answers.where(document: document, user: user)
    answers.max_by(&:integer_value)
  end

  def second_max_answer_on_document_by_user(document, user)
    answers = self.answers.where(document: document, user: user)
    max_answer = max_answer_on_document_by_user(document, user)
    remaining_answers = answers - [max_answer]
    remaining_answers.max_by(&:integer_value)
  end

end
