class CoderController < ApplicationController

  def index
    require 'uri'

    uri = request.url

    @url = URI(uri).path.split('/').last

    if @url != nil
      @url_collection = UrlCollection.select(:longUrl).where(shortUrl: @url).map(&:longUrl)

      if @url_collection[0] != nil
        redirect_to(@url_collection[0])
      else
        redirect_to("localhost:3000")
      end      
    end
  end
  
  def page
    lUrl = params["inputUrl"]

    if lUrl != nil      
      lUrl_db = UrlCollection.find_by_longUrl(lUrl)

      if lUrl_db != nil
        shortUrl = UrlCollection.select(:shortUrl).where(longUrl: lUrl).map(&:shortUrl)

        @longUrl = lUrl
        @shortUrl = shortUrl[0]
      else                
        sUrl = getShortCode

        sUrl_db = UrlCollection.exists?(shortUrl: sUrl)

        if sUrl_db
          while UrlCollection.exists?(shortUrl: sUrl) 
            sUrl = getShortCode
          end
        else
          params = ActionController::Parameters.new({
            urls: {
              shortUrl: sUrl,
              longUrl: lUrl
            }
          })

          permitted = params.require(:urls).permit(:shortUrl, :longUrl)

          @url_item = UrlCollection.new(permitted)
          @url_item.save

          @longUrl = @url_item.longUrl
          @shortUrl = @url_item.shortUrl
        end
      end            
          
    end
  end

  def getShortCode
    symbols = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
    str_code = (0...6).map { symbols[rand(symbols.length)] }.join
 
    return str_code
  end
end
