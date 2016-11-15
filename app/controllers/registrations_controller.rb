class RegistrationsController < Devise::RegistrationsController

  before_action :configure_permitted_parameters

  protected

  def after_update_path_for(resource)
    flash[:notice] = "Account succesfully updated"
    edit_user_registration_path
  end

  def configure_permitted_parameters
#    devise_parameter_sanitizer.permit(:account_update, keys: [:input_mode])
#    devise_parameter_sanitizer.permit(:sign_up, keys: [:input_mode])
  end

end
