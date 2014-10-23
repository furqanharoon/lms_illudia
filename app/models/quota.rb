class Quota < ActiveRecord::Base
	def self.addQuota(leave_days,uid)
		leave_days = leave_days.to_i
		quota = Quota.where("user_id=#{uid}").first
		exceed = 0
		if quota.blank?
			#qr = Quota.new
			avail = 0 + leave_days
			qr = Quota.new(:user_id => uid , :avail => avail , :exceed => 0)
			qr.save
		else
			av = Quota.find_by_user_id(uid)
			av.avail = av.avail + leave_days
			if av.avail > 15
				exceed = av.avail - 15
				#qr = Quota.new(:user_id => uid , :avail => av.avail , :exceed => exceed)
				av = av.update_attributes(:avail => av.avail , :exceed => exceed)
			else
				av = av.update_attributes(:avail => av.avail , :exceed => 0)
				#qr = Quota.new(:user_id => uid , :avail => av.avail , :exceed => 0)
				#qr.save
			end
		end
	end
	
	def self.getQuota(uid)
		user = Quota.find_by_user_id(uid)
		return user.avail , user.exceed
	end
end