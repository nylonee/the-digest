module Tag

  # Tag the given article with its author name
  class TagByAuthor
    def tag_by_author(article)
    	if !article.author.nil? && article.author.length != 0
      		article.tag_list << article.author
      		article.save
      	end
    end
  end


end
