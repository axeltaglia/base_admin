module ApplicationHelper
	def dashboard_url
		return new_user_session_url unless current_user
		return admin_root_path if current_user.is? :admin
		return new_user_session_url
	end
end
