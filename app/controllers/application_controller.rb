class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  #before_action :add_parameters_to_user, if: :devise_controller?

  #def add_parameters_to_user
  #  devise_parameter_sanitizer.for(:signup)<< :first_name
  #  devise_parameter_sanitizer.for(:signup)<< :last_name
  #  devise_parameter_sanitizer.for(:account_update)<< :first_name
  #  devise_parameter_sanitizer.for(:account_update)<< :last_name
  #end

  def ensure_signup_complete
      # Ensure we don't go into an infinite loop
      return if action_name == 'finish_signup'

      # Redirect to the 'finish_signup' page if the user
      # email hasn't been verified yet
      if current_user && !current_user.email_verified?
        redirect_to finish_signup_path(current_user)
      end
    end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :remember_me])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password, :password_confirmation, :remember_me])
  end
end
