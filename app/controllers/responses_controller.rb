class ResponsesController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :set_survey
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  def store
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = @survey.documents.find(params[:document_id])
    end

    def set_survey
      @survey = Survey.find(params[:survey_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:content)
    end

end
