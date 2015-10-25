# Source model for storing and persisting source information
class Source < ActiveRecord::Base
  # name should be included
  validates_presence_of :name

  # A source can have many articles
  has_many :articles
end
