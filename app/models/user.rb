# User model for storing and persisting user information
class User < ActiveRecord::Base
	# Those following informations are required
 	validates_presence_of :email, :first_name, :last_name, :username, :password, :password_confirmation, :bio

 	# Set validates for these values
 	validates :first_name, :last_name, format: { with: /[A-Z]([a-z]+)/, message: "%{value} is not a valid name" }
  	validates :email, format: { with: /(.+)@(.+).[a-z]{2,4}/, message: "%{value} is not a valid email" }
  	validates :username, length: { minimum: 5 }
  	validates :username, uniqueness: true
  	validates :password, :password_confirmation, length: { minimum: 8 }

  	# Include this to store password safely
	has_secure_password

	# many to many relationship with articles (to deal with compiling and emailing)
  	has_and_belongs_to_many :articles

	# User can have tag list named interset list
	acts_as_taggable_on :interests


	# Find a user by username, then check the password is the same
	def self.authenticate username, password
		user = User.find_by(username: username)
		if user && user.authenticate(password)
			return user
		else
			return nil
		end
	end

	# Return full name of a user
	def full_name
		first_name + ' ' + last_name
	end
end