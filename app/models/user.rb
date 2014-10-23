class User < ActiveRecord::Base
	#attr_accessor :password , :login 
	
	def self.authenticate(login, password)
		user = find_by_login(login)
		if user && user.password==password
			user
		else
			nil
		end
	end
	def self.check_user(id)
		user = find_by_id(id)
		if user.admin?
			return true
		else
			return false
		end
	end
end
