class Document < ApplicationRecord
  belongs_to :survey
  has_many :answers, dependent: :destroy
  has_many :questions, through: :survey
  has_many :flags, as: :flaggable, dependent: :destroy

  scope :completed_by_user, -> (user) { where('post_status = ?', post_status) }
  scope :incomplete , -> { where.not(:id => Answer.select(:document_id).uniq) }
  scope :incomplete_by_user , -> (user) { where.not(:id => user.answers.select(:document_id).uniq) }

  def next(user=nil)
    survey.documents.incomplete.order("RANDOM()").first || next_incomplete(user)
  end

  def prev_completed(user)
    #if user has responses for this document
    min_response_id = self.responses.where(user: user).map(&:id).min
    if min_response_id
      user.responses.where("id < ?", min_response_id).last.document
    else
      user.responses.last.document
    end
  end

  def next_completed(user)
    survey.documents.
    #if user has responses for this document
    min_response_id = self.responses.where(user: user).map(&:id).min
    if min_response_id
      user.responses.where("id < ?", min_response_id).last.document
    else
      user.responses.last.document
    end
  end

  def next_incomplete(user)
    survey.documents.incomplete_by_user(user).order("RANDOM()").first
  end

  def completed_by_user?(user)
    user.responses.where(document: self).count == self.questions.count
  end

end
