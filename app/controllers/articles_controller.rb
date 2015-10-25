class ArticlesController < ApplicationController
  # Before actions to check paramters
  before_action :set_article, only: [:show]
  before_action :authenticate_user

  # Set weight constant
  TAGS_WEIGHT = 4
  TITLES_WEIGHT = 3
  SUMMARYS_WEIGHT = 2
  SOURCES_WEIGHT = 1

  # GET /articles
  # GET /articles.json
  # pagination for articles
  def index
    if params[:search]
      my_search
    else
      @articles = Article.all.order(date_time: :desc)
      @articles = Article.paginate(page: params[:page], per_page: 10).order(date_time: :desc)
      @page_title = 'All Articles'
      render 'index'
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  # Show all the articles which match a user's interest
  def my_interests
    # Get all interesting articles to current user and sort them by date_time
    @articles = Article.tagged_with(current_user.interest_list, any: true)
    @articles = @articles.paginate(page: params[:page], per_page: 10).order(date_time: :desc)

    @page_title = 'My Interests'
    render 'index'
  end

  # Show all the articles which match the keyword
  def my_search
    keywords = params[:search].downcase.split(',')

    tags = Article.tagged_with(keywords, any: true).uniq
    titles = Article.all.select { |a| keywords.include?(a.title.downcase) }.uniq
    begin
      summarys = Article.all.select { |a| keywords.include?(a.summary.downcase) }.uniq
    rescue NoMethodError
      summarys = []
    end
    sources = Article.all.select { |a| keywords.include?(a.source.name.downcase) }.uniq

    weight_dictionary = []

    tags.each do |article|
      if weight_dictionary.map { |row| row[0] }.include?(article)
        weight_dictionary[weight_dictionary.map { |row| row[0] }.index(article)] =
          [
            article,
            TAGS_WEIGHT,
            weight_dictionary[weight_dictionary.map { |row| row[0] }.index(article)][2] + 1
          ]
      else
        weight_dictionary << [article, TAGS_WEIGHT, 1]
      end
    end
    titles.each do |article|
      if weight_dictionary.map { |row| row[0] }.include?(article)
        weight_dictionary[weight_dictionary.map { |row| row[0] }.index(article)] =
        [
          article,
          TITLES_WEIGHT,
          weight_dictionary[weight_dictionary.map { |row| row[0] }.index(article)][2] + 1
        ]
      else
        weight_dictionary << [article, TITLES_WEIGHT, 1]
      end
    end
    summarys.each do |article|
      if weight_dictionary.map { |row| row[0] }.include?(article)
        weight_dictionary[weight_dictionary.map { |row| row[0] }.index(article)] =
        [
          article,
          SUMMARYS_WEIGHT,
          weight_dictionary[weight_dictionary.map { |row| row[0] }.index(article)][2] + 1
        ]
      else
        weight_dictionary << [article, SUMMARYS_WEIGHT, 1]
      end
    end
    sources.each do |article|
      if weight_dictionary.map { |row| row[0] }.include?(article)
        weight_dictionary[weight_dictionary.map { |row| row[0] }.index(article)] =
        [
          article,
          SOURCES_WEIGHT,
          weight_dictionary[weight_dictionary.map { |row| row[0] }.index(article)][2] + 1
        ]
      else
        weight_dictionary << [article, SOURCES_WEIGHT, 1]
      end
    end

    unless !weight_dictionary.nil? || !weight_dictionary.empty?
      @articles = [].paginate(page: params[:page], per_page: 10)
      @page_title = 'No results found for: "' + params[:search] + '"'
      render 'index'
    else
      weight_dictionary.each do |row|
        # Only keep searches where ALL keywords have been accounted for
        weight_dictionary.delete(row) if row[2] != keywords.length
      end
      @articles = weight_dictionary.sort_by { |article, _weight, _keyword| article.date_time }.sort_by { |_article, weight, _keyword| weight }.reverse.map { |row| row[0] }
      @articles = @articles.paginate(page: params[:page], per_page: 10)
      @page_title = 'Results for search: "' + params[:search] + '"'
      render 'index'
    end
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
