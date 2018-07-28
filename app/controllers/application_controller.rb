class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(user)
    return admin_users_path if user.is?(:admin)
    return owner_root_path if user.is?(:institution_owner)
  end

  def home
  end
end
