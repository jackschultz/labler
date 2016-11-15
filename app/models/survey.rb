class Survey < ApplicationRecord

  has_many :questions
  has_many :documents

  def incomplete_document_count(user)
    incomplete_document_ids(user).count
  end

  def documents_completed_by_user(user)
    document_ids = user.answers.map(&:document_id).uniq
    documents.where(id: document_ids)
  end

  def documents_not_completed_by_user(user)
    document_ids = incomplete_document_ids(user)
    documents.where(id: document_ids)
  end

  def random_document(user=nil)
    documents.incomplete_by_user(user).order("RANDOM()").first || documents.incomplete.order("RANDOM()").first
  end

  private

  def incomplete_document_ids(user)
    user_answer_document_ids = user.answers.map(&:document_id)
    survey_document_ids = self.documents.map(&:id).uniq
    survey_document_ids - user_answer_document_ids
  end

end
