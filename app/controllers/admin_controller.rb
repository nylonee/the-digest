class AdminController < ApplicationController
	# send digest email to subscribers
	# the digest includes title and link to each article
  def email
  	# Get all users to ask to send a digest 
  	@users = User.find_by(subscribe: true)

  	# Send a digest to each user who asks to  
  	@users.each do |user|
  		# get all the interesting articles and order by date_time
  		articles = Article.tagged_with(user.interest_list, :any => true).order(date_time: :desc)

  	end
  	

  	# redirect to the first page of the website
  	redirect_to login_path
  end


  # scrape(import) all the articles
  def scrape
  	# import all the new articles
  	Importer.new.import_all


		# redirect to the first page   	
  	redirect_to login_path
  end

end
