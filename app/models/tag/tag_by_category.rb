module Tag

  # Tag the given article with its category values
  class TagByCategory
    def self.tag_by_category article
    	# if the categories string is not empty or nil put them as tags
    	if !article.categories.nil? && article.categories.length != 0 
    		article.tag_list << article.categories.split(',')
    		article.tag_list = article.tag_list.flatten
      	article.save
    	end
    end
  end

end
