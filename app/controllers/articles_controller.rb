class ArticlesController < ApplicationController

  # Before actions to check paramters
  before_action :set_article, only: [:show]
  before_action :authenticate_user

  TAG_WEIGHT  = 4

  # GET /articles
  # GET /articles.json
  def index

    @articles = Article.tagged_with(current_user.interest_list, :any => true).to_a
    @articles = Article.all.order(date_time: :desc)
    render 'index'
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

  # Show all the articles which match the keyword
  def my_search
    if params[ :search]
      
      tags = Article.tagged_with(keywords, :any => true)
      titles = Article.all.select{ |a| a.title.in?(keywords)}
      summarys = Article.all.select{}
      sourceS = Article.all.select{a.source.name}

      tags= tags.uniq
      titles = titles.uniq


      weight_dictionary = {}

      tags.each do |tag|
        weight_dictionary[tag] = TAG_WEIGHT
      end



      #articles = Article.search(params[:search].order("created_at DESC"))
    else
      articles = Article.order("created_at DESC")
    end
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
