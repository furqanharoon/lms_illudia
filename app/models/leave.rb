class Leave < ActiveRecord::Base
	before_save :default_values
	validates :start_date , :presence => true
	def default_values
		self.status ||= "Pending"  
	end
	
	def self.addQuota(leave_status,leave_days,user_id)
		self.avail=self.avail + leave_days
		self.user_id= user_id
	end

	def self.getDate(month)
		month = month.to_s
		year = Time.now.year
		year = year.to_s
		month = year + month
		month = month.to_date
		month = month.beginning_of_month
		month_name = month.strftime("%B")
		month_end = month.end_of_month
		return month , month_end , month_name
	end

	def self.dateDiff(month_start,month_end,current_id)
		@month_start , @month_end = month_start , month_end
		#@month_start = @month_start.to_date
		@adjust = @month_start
		@adjust = @adjust - 7.day
		#@adjust = @adjust.beginning_of_month
		@adjust_end = @adjust.end_of_month
		@year_start = Date.today.beginning_of_year #Leaves by year
	    @year_end = Date.today.end_of_year
	    @date_today = Date.today
	    @leave_year = Leave.find_by_sql("SELECT SUM(myview.days) AS no_leaves FROM (SELECT DATEDIFF(end_date, start_date) AS days FROM leaves WHERE user_id= #{current_id}  AND status = 'Approved' AND start_date >= '#{@year_start}' AND end_date <= '#{@date_today}') AS myview")

	    
  		@leave_month = Leave.find_by_sql("SELECT SUM(myview.days) AS no_leaves FROM (SELECT DATEDIFF(end_date, start_date) AS days FROM leaves WHERE user_id= #{current_id} AND status = 'Approved' AND start_date >= '#{@month_start}' AND end_date <= '#{@month_end}') AS myview")


  		@leave_m = Leave.find_by_sql("SELECT SUM(myview.days) AS no_leaves1 FROM (SELECT DATEDIFF(end_date, start_date) AS days FROM leaves WHERE user_id= #{current_id} AND status = 'Approved' AND start_date >= '#{@adjust}' AND start_date <= '#{@adjust_end}' AND end_date <= '#{@month_end}') AS myview")

  		@lm = @leave_m[0].no_leaves1
  		@lm = @lm.to_i
  		if @lm != 0
  			@lm = @lm + 1
  		end

  		@by_month = @leave_month[0].no_leaves
	    @by_month = @by_month.to_i
	    if @by_month != 0
	    	@by_month = @by_month + 1
	    end
	    
	    @by_month = @by_month + @lm
	    @by_year = @leave_year[0].no_leaves
	    return @by_month , @by_year ,@lm
	end
end