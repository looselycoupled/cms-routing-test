class Page < ActiveRecord::Base
  attr_accessible :content, :path, :title
end
