# include modules required
include Scrape
#include Tag

# importer class which import new articles using Scrape and Tag modules
class Importer

	def initialize
		@new_articles = []
	end

	# import all new articles
	def import_all
		scrape_all
		tag_all
	end


	# scrape all new articles
	def scrape_all

		ActiveRecord::Base.transaction do
			abc = Scrape::TheAbcScraper.new
			@new_articles << abc.scrape

			sbs = Scrape::TheSbsScraper.new
	    @new_articles << sbs.scrape

	    guardian = Scrape::TheGuardianScraper.new
	    @new_articles << guardian.scrape

	    sydney = Scrape::TheSydneyMorningHeraldScraper.new
	    @new_articles << sydney.scrape

	    new_york = Scrape::TheNewYorkTimesScraper.new
	    @new_articles << new_york.scrape

			age = Scrape::TheAgeScraper.new
			@new_articles << age.scrape
		end

    @new_articles = @new_articles.flatten

	end


	# tag all new articles
	def tag_all
		ActiveRecord::Base.transaction do
			@new_articles.each do |a|
				Tag::TagBySource.tag_by_source(a)
				Tag::TagByAuthor.tag_by_author(a)
				Tag::TagByCategory.tag_by_category(a)
				a.tag_list = a.tag_list.uniq
				a.save
			end
		end
	end

end
