#include mindrill module
require 'rubygems'
require 'bundler/setup'
require 'mandrill'


class AdminController < ApplicationController

  # maximum number of articles per one email
  MAX_NUM_ARTICLES = 10


	# send digest email to subscribers
	# the digest includes title and link to each article
  def email

  	# Get all users to ask to send a digest 
    users = User.where(subscribe: true)

    # Get mandril object
    mandrill = Mandrill::API.new 'SyKEz-QytC97dIODlvKQoQ'
    content = "Here is the list of interesting articles for you\n\n"

  	# Send a digest to each user who asks to  
  	users.each do |user|
  		# get all the interesting articles and order by date_time
  		articles = Article.tagged_with(user.interest_list, :any => true).order(date_time: :desc)

      # get at most 10 new interesting articles
      num = 0
      articles.each do |article|

        # if 10 interesting articles are extracted, break the loop
        if num >= MAX_NUM_ARTICLES
          break
        end

        # if this article is not linked to this user, include this to digest
        if !user.articles.include? (article)
          user.articles << article
          content += make_paragraph(article.title, article.link)
          num += 1
        end

      end

      # If there is no interesting article
      if num == 0
        content = "There is no any new interesting articles for you this time.\n"
      end

      # create a message to send
      message = {  
            :subject => 'Hello, ' + user.first_name + '. This is the digest you required',  
            :from_name => 'The Digest',  
            :text => content,  
            :to => [  
                {  
                :email => user.email,  
                :name => user.first_name + ' ' + user.last_name 
                }  
            ],   
            :from_email => 'thedigest@thedigest.com'
          }  

      # send the message
      sending = mandrill.messages.send message 

  	end
  	
  	# redirect to the first page of the website
  	redirect_to login_path
  end


  # make a proper paragraph with title and link
  def make_paragraph (title, link)
    paragraph = "Title: #{title}\n"
    paragraph += "Link: #{link}\n\n" 
  end


  # scrape(import) all the articles
  def scrape
  	# import all the new articles
  	Importer.new.import_all


		# redirect to the first page   	
  	redirect_to login_path
  end

end
