# include modules required
include Scrape
#include Tag

# importer class which import new articles using Scrape and Tag modules
class Importer

	def initialize
		@new_articles = []

		# Initialize the tagging classes
		@tsource = Tag::TagBySource.new
		@tauthor = Tag::TagByAuthor.new
		@tcategory = Tag::TagByCategory.new
		@tsummary = Tag::TagBySummary.new
		@ttitle = Tag::TagByTitle.new
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
		threads = []
		ActiveRecord::Base.transaction do
			@new_articles.each do |a|
				begin
					@tsource.tag_by_source(a)
				rescue
					puts "Tagging article by source failed"
				end

				begin
					@tauthor.tag_by_author(a)
				rescue
					puts "Tagging article by author failed"
				end

				begin
					@tcategory.tag_by_category(a)
				rescue
					puts "Tagging article by category failed"
				end

				# These take forever, so it's put on a concurrent thread.
				# NOTE: We are using sqlite which does not natively support concurrent
				# transactions, therefore we increased transaction timeout and pool, and
				# minimized the number of concurrent transactions we're processing as
				# much as possible.
				threads << Thread.new {
					begin
						@tsummary.tag_by_summary(a)
					rescue
						puts "Tagging article by summary failed"
					end

					begin
						@ttitle.tag_by_title(a)
					rescue
						puts "Tagging article by title failed"
					end
				}
				a.tag_list = a.tag_list.uniq
				a.save
			end

		end
	end

end
