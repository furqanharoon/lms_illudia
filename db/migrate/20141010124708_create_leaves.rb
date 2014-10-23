class CreateLeaves < ActiveRecord::Migration
  def change
    create_table :leaves do |t|
    	t.integer "user_id"
    	t.date "start_date"
    	t.date "end_date"
    	t.text "description"
    	t.string "status"
    	t.integer "total_days"


      t.timestamps
    end
  end
end
