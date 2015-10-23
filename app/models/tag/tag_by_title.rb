require 'rubygems'
require 'bundler/setup'
require 'open_calais'


module Tag

  # Tag the given article with its title
  # Uses OpenCalais gem
  class TagByTitle
  	# get the api key
  	API_KEY = 'IimOdVwVdVA5hYuyPPvt2GS0xNqir92u'

  	def self.tag_by_title (article)
  		if !article.title.nil? && article.title.length != 0 
  			
				# create an client object with the api key
				oc = OpenCalais::Client.new(api_key: API_KEY)

				# Analyse the title of this article
				oc_response = oc.enrich article.title

				# put every topic keywords into the tag_list
				oc_response.topics.each do |topic|
					article.tag_list << topic[:name]
				end

				# save the article
				article.save

  		end
		end
  end

end
