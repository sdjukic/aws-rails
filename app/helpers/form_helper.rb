module FormHelper
	def setup_user(user)
		user.user_resource.build
		user
	end
end
