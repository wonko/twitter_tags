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
  end
  
  describe '<r:twitter:tweets>' do    
    it 'should give no output' do
      tag = %{<r:twitter user='openminds_be'><r:tweets></r:tweets></r:twitter>}
      expected = ''

      pages(:home).should render(tag).as(expected)
    end
    
    it 'should give the last 10 tweets by default' do
      tag = %{<r:twitter user='openminds_be'><r:tweets><r:tweet>.</r:tweet></r:tweets></r:twitter>}
      expected = '.' * 10

      pages(:home).should render(tag).as(expected)
    end

    it 'should honour the count attribute' do
      tag = %{<r:twitter user='openminds_be'><r:tweets count="5"><r:tweet>.</r:tweet></r:tweets></r:twitter>}
      expected = '.' * 5

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
    
    it 'should honour the order attribute' do
      flunk
    end
  end
    
  describe '<r:twitter:tweets:tweet>' do
    it 'should give no output' do
      tag = %{<r:twitter user='openminds_be'><r:tweets><r:tweet></r:tweet></r:tweets></r:twitter>}
      expected = ''

      pages(:home).should render(tag).as(expected)
      
    end
  end  
    
  describe '<r:twitter:tweets:tweet:text>' do
    it 'should give the text of the tweet' do
      flunk
    end
  end  
    
  describe '<r:twitter:tweets:tweet:datetime>' do
    it 'should give the date & time of the tweet' do
      flunk
    end
  end  
  
  describe '<r:twitter:tweets:tweet:url>' do
    it 'should give the url to the tweet' do
      flunk
    end
  end  
end
