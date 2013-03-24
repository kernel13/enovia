class Post < ActiveRecord::Base
	acts_as_taggable

	scope :published, where(:published => true)
	
  	attr_accessible :content, :title, :tag_list, :published

  	searchable :if => :published do
  		text :title, :content
  		text :tag_list
  	end
end
