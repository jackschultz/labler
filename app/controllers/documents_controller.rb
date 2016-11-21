class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy, :responses]
  before_action :set_survey, only: [:show, :edit, :update, :destroy, :responses]
  before_action :authenticate_user!, only: [:responses]

  def index
    @documents = Document.all
  end

  def show

    question = @survey.questions.first #crappy way, but we know we want the first question
    if current_user
      answers = current_user.answers.where(document: @document, question: question)
      if answers.any?
        primary_answer = question.max_answer_on_document_by_user(@document, current_user)
        @primary_label = primary_answer.question_choice.short_label
        if @primary_label == "other"
          @primary_other_value = primary_answer.string_value
        end
        secondary_answer = question.second_max_answer_on_document_by_user(@document, current_user)
        if secondary_answer.integer_value.to_i == 0
          @secondary_label = "none"
        else
          @secondary_label = secondary_answer.question_choice.short_label
        end
        if @secondary_label == "other"
          @secondary_other_value = @response_group.second_max_response.value
        end
        @equal = primary_answer.integer_value == secondary_answer.integer_value
      end
      @flag = @document.flags.find_or_initialize_by(user: current_user)
    end

  end

  def new
    @document = Document.new
  end

  def edit
  end

  def create
    @document = @survey.documents.new(document_params)

    respond_to do |format|
      if @document.save
        format.html { redirect_to @document, notice: 'Document was successfully created.' }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
        format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url, notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def responses
    answers = []
    questions_params = params[:document][:questions]
    questions_params.each do |question_id|
      answer_params = questions_params[question_id]
      question = @survey.questions.find(question_id.to_i)
      #error if doesn't exist
      if question.question_type == "multi_value_number"
        if simple_answer_params["used_simple"] == "true"
          answers = answers + intepret_multi_value_number_simple_question(question, answer_params)
        else
          answers = answers + intepret_multi_value_number_question(question, answer_params)
        end
      elsif question.question_type == "text"
        answers << intepret_string_question(question, answer_params)
      elsif question.question_type == "radio"
        answers << intepret_radio_question(question, answer_params)
      end
    end
    respond_to do |format|
      if Answer.transaction { answers.each{|a| a.save} }
        format.html do
          redirect_to @document.next || @survey
          flash[:success] = "Response successfully logged"
        end
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    def set_survey
      @survey = @document.survey#Survey.find(params[:survey_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:content)
    end

    def response_params
      params.require(:document).permit(:questions_attributes => [:id, { :question_attributes_attributes => [:id, { :response => [:amount, :value, :question_attribute_id] } ] } ])
    end

    def simple_answer_params
      params.require(:answers).permit(:used_simple, :advanced, :primary_group, :primary_other_text, :secondary_group, :secondary_other_text, :equal)
    end

    def intepret_multi_value_number_question(question, answer_params)
      answers = []
      answer_params[:answers].each do |key, value|
        qcid = value[:question_choice_id].to_i
        answer = current_user.answers.find_or_initialize_by(question: question, document: @document, question_choice_id: qcid)
        string_value = value[:string_value]
        integer_value = value[:integer_value].to_i || 0
        answer.question_choice_id = qcid
        answer.string_value = string_value
        answer.integer_value = integer_value
        answers << answer
      end
      answers
    end

    def intepret_multi_value_number_simple_question(question, answer_params)
      primary = simple_answer_params["primary_group"]
      primary_other_text = nil
      if primary == "other"
        primary_other_text = simple_answer_params["primary_other_text"]
      end

      secondary = simple_answer_params["secondary_group"]
      secondary_other_text = nil
      if secondary == "other"
        secondary_other_text = simple_answer_params["secondary_other_text"]
      end

      if primary == secondary
        secondary = "none"
        primary = "none"
      end

      if primary == "none" && secondary == "none"
        answers = question.answers.where(user: current_user, document: @document)
        answers.destroy_all
        flash[:error] = "Cannot have two none selections"
        return redirect_to @document
      elsif primary == "other" and secondary == "other"
        response_group.responses.destroy_all
        response_group.destroy
        flash[:error] = "Cannot have two other selections"
        return redirect_to @document
      elsif secondary == "none"
        primary_amount = 100
        secondary_amount = 0
      elsif simple_answer_params["equal"] == "on"
        primary_amount = 50
        secondary_amount = 50
      else
        primary_amount = 75
        secondary_amount = 25
      end

      answers = []
      question.question_choices.each do |qc|
        answer = current_user.answers.find_or_initialize_by(question: question, document: @document, question_choice: qc)
        if qc.short_label == "other"
          answer.string_value = primary_other_text || secondary_other_text
        end
        if primary == qc.short_label
          answer.integer_value = primary_amount
        elsif secondary == qc.short_label
          answer.integer_value = secondary_amount
        else
          answer.integer_value = 0
        end
        answers << answer
      end
      answers
    end

    def intepret_radio_question(question, answer_params)
      answer = current_user.answers.find_or_initialize_by(question: question, document: @document)
      qcid = answer_params[:answer][:question_choice_id]
      answer.question_choice_id = qcid.to_i
      answer
    end

    def intepret_string_question(question, answer_params)
      string_value = answer_params[:answer][:string_value]
      answer = current_user.answers.find_or_initialize_by(question: question, document: @document)
      answer.string_value = string_value
      answer
    end

end
