class ChangeDateTimeTypeInArticles < ActiveRecord::Migration
  def change
  	change_column :articles, :date_time, :datetime
  end
end
