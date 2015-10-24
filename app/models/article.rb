# Article model for storing and persisting article information
class Article < ActiveRecord::Base
	# title and date_time should be included
	validates_presence_of :title, :date_time 
	
	# An article should belong to some source
	belongs_to :source

	# Tags can be attached
	acts_as_taggable
end
