require 'twitter'

class TwitterEngine
  def self.print_search search_string
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "QpxDmEy2sfNN4MNzKXihk0GwQ"
      config.consumer_secret     = "vlMiEiwYA3y1iw00jwoAHoo7q33v7UX1vaPn73Dq6zLPX02oGI"
      config.access_token        = "354589333-0EFXMVUvR5MrukVUtGHVCSunHrrzSmYVy1BE2Afq"
      config.access_token_secret = "q4KBVMmiRQkgR2jE9cZHeQjZeXtU7FDABimiexQoEr2mo"
    end

    client.search(search_string, :result_type => "recent").take(3).each do |tweet|
      puts tweet.text
    end
  end
end
