module Tag

  # Tag the given article with its source name
  class TagBySource
    def self.tag_by_source article
      article.tag_list << article.source.name
      article.save
    end
  end


end
