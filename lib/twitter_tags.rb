module TwitterTags
  include Radiant::Taggable
  
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  
  include Rack::Utils
  alias_method :h, :escape_html

  desc "Creates an context for the twitter functionality" 
  tag "twitter" do |tag|
    # we need a user in the user attribute
    raise StandardError::new('the twitter-tag needs a username in the user attribute') if tag.attr['user'].blank?
    tag.locals.user = tag.attr['user']
    tag.expand
  end

  desc "Creates the loop for the tweets - takes count and order optionally"
  tag "twitter:tweets" do |tag|
    count = (tag.attr['count'] || 10).to_i # reminder: "foo".to_i => 0
    order = (tag.attr['order'] || 'desc').downcase
    
    raise StandardError::new('the count attribute should be a positive integer') unless count > 0
    raise StandardError::new('the order attribute should be "asc" or "desc"') unless %w{asc desc}.include?(order)

    # iterate over the tweets
    result = []
    Twitter::Search.new.from(tag.locals.user).per_page(count).each do |tweet|
      tag.locals.tweet = tweet
      result << tag.expand
    end
    
    result
  end
  
  desc "Creates the context within which the tweet can be examined"
  tag "twitter:tweets:tweet" do |tag|
    tag.expand
  end
  
  desc "Returns the text from the tweet"
  tag "twitter:tweets:tweet:text" do |tag|
    tweet = tag.locals.tweet
    tweet['text']
  end
  
  desc "Returns the text from the tweet with hyperlinked usernames and URLs"
  tag "twitter:tweets:tweet:formatted_text" do |tag|
    tweet = tag.locals.tweet
    format_tweet tweet['text']
  end
  
  def format_tweet(text)
    text = html_escape(text)
    text = link_urls(text)
    text = link_usernames(text)
    text = link_hashtags(text)
    text = format_newlines(text)
    text
  end
  
  def link_hashtags(text)
    text.gsub(/(^|\s|\(|\)\[|\]\{|\})\#([^\(\)\[\]\{\}\:\s]+)/) do
      $1 + link_to("##{ $2 }", "http://twitter.com/search?q=%23#{ escape($2) }", :class=>"twitter_hashtag", :target=>"_blank")
    end
  end
  
  def link_usernames(text)
    text.gsub(/(^|\s|\(|\)\[|\]\{|\})@([^\(\)\[\]\{\}\:\s]+)/) do
      $1 + link_to("@#{ $2 }", "http://twitter.com/#{ escape($2) }", :class=>"twitter_username", :target=>"_blank")
    end
  end
  
  def link_urls(text)
    text.gsub(%r{(http://[^\(\)\[\]\{\}\s]+?)($|[.;:\)\]\}] | )}i) do
      link_to(escape_html($1), $1) + $2
    end
  end
  
  def format_newlines(text)
    text = text.gsub(/\n/, "<br />")
    text = text.gsub(%r{<br />\s*<br />}, "</p><p>")
    "<p>#{text}</p>"
  end
  
  desc "Returns the date & time from the tweet"
  tag "twitter:tweets:tweet:date" do |tag|
    tweet = tag.locals.tweet
    date = Time.zone.parse tweet['created_at']
    format = tag.attr['format'] || '%a, %d %b %Y %H:%M:%S %z'
    date.strftime format
  end

  desc "Returns the url from the tweet"
  tag "twitter:tweets:tweet:url" do |tag|
    tweet = tag.locals.tweet
    
    "http://www.twitter.com/#{tag.locals.user}/statuses/#{tweet['id']}"
  end
end
