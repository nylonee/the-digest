# include modules required
include Scrape
#include Tag

# importer class which import new articles using Scrape and Tag modules
class Importer

	# import all new articles
	def import_all
		scrape_all
		tag_all
	end


	# scrape all new articles
	def scrape_all
		abc = Scrape::TheAbcScraper.new
		abc.scrape

		sbs = Scrape::TheSbsScraper.new
    sbs.scrape

    guardian = Scrape::TheGuardianScraper.new
    guardian.scrape

    sydney = Scrape::TheSydneyMorningHeraldScraper.new
    sydney.scrape

    new_york = Scrape::TheNewYorkTimesScraper.new
    new_york.scrape		
    
	end


	# tag all new articles
	def tag_all

	end

end