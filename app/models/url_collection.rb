class UrlCollection < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection 
  attr_accessible :longUrl, :shortUrl
end
