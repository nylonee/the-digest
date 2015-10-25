# Import necessary ruby gems
require 'rubygems'
require 'bundler/setup'
require 'open_calais'


module Tag

  # Tag the given article with its title
  # Uses OpenCalais gem
  class TagByTitle


    def initialize

      #api_key = 'IimOdVwVdVA5hYuyPPvt2GS0xNqir92u' tessa
      api_key = 'nmECknxxPjH8GNjLE9Ar29VL9nDN1Rdj' # Nihal

      # create an client object with the api key
      @oc = OpenCalais::Client.new(api_key: api_key)

    end

  	def tag_by_title (article)
  		if !article.title.nil? && article.title.length != 0

				# Analyse the title of this article
				oc_response = @oc.enrich article.title

				# put every topic keywords into the tag_list
				oc_response.topics.each do |topic|
					article.tag_list << topic[:name].split('&')
				end

        oc_response.tags.each do |tag|
          article.tag_list << tag[:name].split('&')
        end

  		end

      article.save

		end

  end

end
