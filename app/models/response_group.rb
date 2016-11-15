class ResponseGroup < ApplicationRecord

  belongs_to :user
  belongs_to :document

  has_many :responses

  def max_response
    responses.max_by(&:integer_value)
  end

  def second_max_response
    [responses - [max_response]].first.max_by(&:integer_value)
  end

end
