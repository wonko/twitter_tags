require File.dirname(__FILE__) + '/../spec_helper'

describe 'TwitterTags' do
  dataset :pages

  describe '<r:twitter>' do
    it 'should require a twitter name in the name attribute' do
      tag = %{<r:twitter />}
      
      pages(:home).should render(tag).with_error('the twitter-tag needs a username in the user attribute')
    end
    
    it 'should give no output' do
      tag = %{<r:twitter user='openminds_be' />}
      expected = ''
      
      pages(:home).should render(tag).as(expected)      
    end

    it 'should pass the username down to the tweet-directive' do
      tag = %{<r:twitter user='openminds_be'><r:tweets>.</r:tweets></r:twitter>}

      twitter_search_obj = Twitter::Search.new
      Twitter::Search.should_receive(:new).and_return(twitter_search_obj)
      twitter_search_obj.should_receive(:from).with('openminds_be').and_return(twitter_search_obj)

      pages(:home).should render(tag).matching(//)
    end

  end
  
  describe '<r:twitter:tweets>' do    
    
    it 'should give no output' do
      tag = %{<r:twitter user='openminds_be'><r:tweets></r:tweets></r:twitter>}
      expected = ''

      twitter_search_obj = Twitter::Search.new
      Twitter::Search.should_receive(:new).and_return(twitter_search_obj)
      twitter_search_obj.should_receive(:from).with('openminds_be').and_return(twitter_search_obj)
      twitter_search_obj.should_receive(:per_page).with(10).and_return(%w{a b c d e f g h i j})

      pages(:home).should render(tag).as(expected)
    end
    
    it 'should give the last 10 tweets by default' do
      tag = %{<r:twitter user='openminds_be'><r:tweets><r:tweet>.</r:tweet></r:tweets></r:twitter>}
      expected = '.' * 10

      twitter_search_obj = Twitter::Search.new
      Twitter::Search.should_receive(:new).and_return(twitter_search_obj)
      twitter_search_obj.should_receive(:from).with('openminds_be').and_return(twitter_search_obj)
      twitter_search_obj.should_receive(:per_page).with(10).and_return(%w{a b c d e f g h i j})

      pages(:home).should render(tag).as(expected)
    end

    it 'should honour the count attribute' do
      tag = %{<r:twitter user='openminds_be'><r:tweets count="5"><r:tweet>.</r:tweet></r:tweets></r:twitter>}
      expected = '.' * 5

      twitter_search_obj = Twitter::Search.new
      Twitter::Search.should_receive(:new).and_return(twitter_search_obj)
      twitter_search_obj.should_receive(:from).with('openminds_be').and_return(twitter_search_obj)
      twitter_search_obj.should_receive(:per_page).with(5).and_return(%w{a b c d e})      

      pages(:home).should render(tag).as(expected)
    end

    it 'should throw an error when the count attribute is not numeric' do
      tag = %{<r:twitter user='openminds_be'><r:tweets count="foo" /></r:twitter>}

      pages(:home).should render(tag).with_error('the count attribute should be a positive integer')
    end

    it 'should throw an error when the count attribute is a negative' do
      tag = %{<r:twitter user='openminds_be'><r:tweets count="-10" /></r:twitter>}

      pages(:home).should render(tag).with_error('the count attribute should be a positive integer')
    end
    
    # it 'should honour the order attribute' do
    #   flunk
    # end
  end
    
  describe '<r:twitter:tweets:tweet>' do
    it 'should give no output' do
      tag = %{<r:twitter user='openminds_be'><r:tweets><r:tweet></r:tweet></r:tweets></r:twitter>}
      expected = ''

      twitter_search_obj = Twitter::Search.new
      Twitter::Search.should_receive(:new).and_return(twitter_search_obj)
      twitter_search_obj.should_receive(:from).with('openminds_be').and_return(twitter_search_obj)
      twitter_search_obj.should_receive(:per_page).with(10).and_return(%w{a b c d e f g h i j})      

      pages(:home).should render(tag).as(expected)
      
    end
  end  
    
  describe '<r:twitter:tweets:tweet:text>' do
    it 'should give the text of the tweet' do
      tag = %{<r:twitter user='openminds_be'><r:tweets count="1"><r:tweet:text /></r:tweets></r:twitter>}
      expected = 'text 1'

      tweets = [
        {"text"=>"text 1",  "created_at"=>"Mon, 23 Feb 2009 12:34:56 +0000", "to_user_id"=>nil, "from_user"=>"openminds_be", "id"=>1240985884, "from_user_id"=>1621731, "iso_language_code"=>"nl", "source"=>"&lt;a href=&quot;http://twitter.com/&quot;&gt;web&lt;/a&gt;", "profile_image_url"=>"http://s3.amazonaws.com/twitter_production/profile_images/60061505/logo-vierkant_normal.png"},
        ]

      twitter_search_obj = Twitter::Search.new
      Twitter::Search.should_receive(:new).and_return(twitter_search_obj)
      twitter_search_obj.should_receive(:from).with('openminds_be').and_return(twitter_search_obj)
      twitter_search_obj.should_receive(:per_page).with(1).and_return(tweets)      

      pages(:home).should render(tag).as(expected)
    end
  end  
    
  describe '<r:twitter:tweets:tweet:date>' do
    it 'should give the date & time of the tweet' do
      tag = %{<r:twitter user='openminds_be'><r:tweets count="1"><r:tweet:date /></r:tweets></r:twitter>}
      expected = 'Mon, 23 Feb 2009 12:34:56 +0000'

      tweets = [
        {"text"=>"text 1",  "created_at"=>"Mon, 23 Feb 2009 12:34:56 +0000", "to_user_id"=>nil, "from_user"=>"openminds_be", "id"=>1240985884, "from_user_id"=>1621731, "iso_language_code"=>"nl", "source"=>"&lt;a href=&quot;http://twitter.com/&quot;&gt;web&lt;/a&gt;", "profile_image_url"=>"http://s3.amazonaws.com/twitter_production/profile_images/60061505/logo-vierkant_normal.png"},
        ]

      twitter_search_obj = Twitter::Search.new
      Twitter::Search.should_receive(:new).and_return(twitter_search_obj)
      twitter_search_obj.should_receive(:from).with('openminds_be').and_return(twitter_search_obj)
      twitter_search_obj.should_receive(:per_page).with(1).and_return(tweets)      

      pages(:home).should render(tag).as(expected)
    end
  end  
  
  describe '<r:twitter:tweets:tweet:url>' do
    it 'should give the url to the tweet' do
      tag = %{<r:twitter user='openminds_be'><r:tweets count="1"><r:tweet:url /></r:tweets></r:twitter>}
      expected = 'http://www.twitter.com/openminds_be/statuses/1240985884'

      tweets = [
        {"text"=>"text 1",  "created_at"=>"Mon, 23 Feb 2009 12:34:56 +0000", "to_user_id"=>nil, "from_user"=>"openminds_be", "id"=>1240985884, "from_user_id"=>1621731, "iso_language_code"=>"nl", "source"=>"&lt;a href=&quot;http://twitter.com/&quot;&gt;web&lt;/a&gt;", "profile_image_url"=>"http://s3.amazonaws.com/twitter_production/profile_images/60061505/logo-vierkant_normal.png"},
        ]

      twitter_search_obj = Twitter::Search.new
      Twitter::Search.should_receive(:new).and_return(twitter_search_obj)
      twitter_search_obj.should_receive(:from).with('openminds_be').and_return(twitter_search_obj)
      twitter_search_obj.should_receive(:per_page).with(1).and_return(tweets)      

      pages(:home).should render(tag).as(expected)
    end
  end  
end
