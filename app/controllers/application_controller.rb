class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_up_path_for(resource)
    survey_path(Survey.first)
  end

  def after_sign_in_path_for(resource)
    survey_path(Survey.first)
  end

  def after_update_path_for(resource)
    survey_path(Survey.first)
  end

end
