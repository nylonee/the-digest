class AdminController < ApplicationController
	# send digest email to subscribers
  def email
  	# Get all users to ask to send a digest 
  	@users = User.find_by(subscribe: true)


  end


  # scrape(import) all the articles
  def scrape
  	Importer.new.import_all
  end

end
