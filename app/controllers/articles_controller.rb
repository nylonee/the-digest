class ArticlesController < ApplicationController

  # Before actions to check paramters
  before_action :set_article, only: [:show]
  before_action :authenticate_user


  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.all.reverse
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  # Show all the articels which match a user's interest
  def my_interests
    @articles = Article.tagged_with(current_user.interest_list, :any => true).to_a
    @articles = @articles.reverse
    render 'index'
  end


  # Refresh the articles by calling the scrape function from all the importers
  def refresh
    sbs_impt = TheSbsImporter.new
    sbs_impt.scrape

    guardian_impt = TheGuardianImporter.new
    guardian_impt.scrape

    sydney_impt = TheSydneyMorningHeraldImporter.new
    sydney_impt.scrape

    new_york_impt_fashion = TheNewYorkTimesImporter.new("fashion")
    new_york_impt_fashion.scrape

    new_york_impt_science = TheNewYorkTimesImporter.new("science")
    new_york_impt_science.scrape

    new_york_impt_singer = TheNewYorkTimesImporter.new("singer")
    new_york_impt_singer.scrape

    age_impt = TheAgeImmporter.new
    age_imp.scrape

    # Redirect to articles_path
    redirect_to articles_path
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :date, :summary, :author, :image, :link, :tag_list)
    end
end
