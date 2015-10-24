class ArticlesController < ApplicationController

  # Before actions to check paramters
  before_action :set_article, only: [:show]
  before_action :authenticate_user


  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.all.order(date_time: :desc)
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  # Show all the articels which match a user's interest
  def my_interests
    @articles = Article.tagged_with(current_user.interest_list, :any => true)
    @articles = @articles.order(date_time: :desc)
    render 'index'
  end


  # Refresh the articles by calling the scrape function from all the importers
  def refresh

    Importer.new.import_all

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
