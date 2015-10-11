class SessionsController < ApplicationController

  # Before actions to check paramters
  before_action :check_params, only: [:login]
  before_action :authenticate_user, only: [:logout]

  # Road the login page
  def unauth
    # If there is a current user, rediret to articles page
    if current_user
      redirect_to articles_path
    end
  end


  # Find a user with the password and username pair, log in that user if they exist 
  def login
  	# Find a user with params
  	user = User.authenticate(@credentials[:username], @credentials[:password])
  	if user
	  	# Save them in the session
	  	log_in user
	  	# Redirect to articles page
	  	redirect_to articles_path
	  else
		  redirect_to :back
	  end
  end


  # Log out the user in the session and redirect to the unauth thing
  def logout
  	log_out
  	redirect_to login_path 
  end


  # Private controller methods
  private
  def check_params
  	params.require(:credentials).permit(:password, :email)
  	@credentials = params[:credentials]
  end

end
