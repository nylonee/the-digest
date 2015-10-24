require 'rubygems'
require 'bundler/setup'
require 'alchemy_api'

module Tag

  # Tag the given article with its summary
  # Uses Alchemy ruby gem
  class TagBySummary

    def initialize
      # get the api key tessa
      #AlchemyAPI.key = '7c716e88e4261f02196b83ce0abd59637e2cf8fc'

      # Nihal
			AlchemyAPI.key = 'c034f2a7188c38fd165d49a67cf50650c7003d74'      

      @a_entities = AlchemyAPI::EntityExtraction.new()
      @a_concepts = AlchemyAPI::ConceptTagging.new()

    end


  	def tag_by_summary (article)

      # Initialize entities and concepts
      a_entities ||= []
      a_concepts ||= []

			# get all the entities from summary and put in the tag list
			a_entities = @a_entities.search(text: article.summary)
			a_entities.each do |e|
				article.tag_list << e['text']
			end

			# get all the concepts from summary and put in the tag list
			a_concepts = @a_concepts.search(text: article.summary)
			a_concepts.each do |c|
				article.tag_list << c['text']
			end
      article.save
		end

  end

end
