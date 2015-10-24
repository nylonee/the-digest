# Article model for storing and persisting article information
class Article < ActiveRecord::Base
	# title and date_time should be included
	validates_presence_of :title, :date_time 
	
	# An article should belong to some source
	belongs_to :source

	# many to many relationship with users (to deal with compiling and emailing)
  	has_and_belongs_to_many :users

	# Tags can be attached
	acts_as_taggable
end
