module ApplicationHelper
	def is_admin?
		redirect_to root_url unless current_user.admin?
	end
end
