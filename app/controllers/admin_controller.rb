# include mandrill module
require 'rubygems'
require 'bundler/setup'
require 'mandrill'

# Admin controller class dealing with the two admin get requests(scrape, email)
class AdminController < ApplicationController
  # Maximum number of articles per one email
  MAX_NUM_ARTICLES = 10

  # Send digest email to all subscribers
  # The digest includes titles and links of articles
  def email
    # redirect to the first page of the website
    redirect_to login_path

    # Get all users who subscribe
    users = User.where(subscribe: true)

    # Get mandril object
    mandrill = Mandrill::API.new 'SyKEz-QytC97dIODlvKQoQ'

    # Send a digest to each user
    users.each do |user|
      # Set the elementary content string
      content = "Here is the list of interesting articles for you\n\n"

      # Get all the interesting articles and order by date_time
      articles = Article.tagged_with(user.interest_list, any: true).order(date_time: :desc)

      # Get at most 10 new interesting articles
      num = 0
      articles.each do |article|
        # If 10 interesting articles are already extracted, break the loop
        break if num >= MAX_NUM_ARTICLES

        # If this article has not been sent to this user, include this to digest
        unless user.articles.include?(article)
          user.articles << article
          # Update content string
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
        subject: 'Hello, ' + user.first_name + '. This is the digest you required',
        from_name: 'The Digest',
        text: content,
        to: [
          {
            email: user.email,
            name: user.first_name + ' ' + user.last_name
          }
        ],
        from_email: 'thedigest@thedigest.com'
      }

      # send the email
      mandrill.messages.send message
    end
  end

  # make a proper paragraph with title and link given
  def make_paragraph(title, link)
    paragraph = "Title: #{title}\n"
    paragraph + "Link: #{link}\n\n"
  end

  # scrape(import) all the articles
  def scrape
    # import all the new articles
    Importer.new.import_all

    # redirect to the first page
    redirect_to login_path
  end
end
