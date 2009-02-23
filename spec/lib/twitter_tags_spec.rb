require File.dirname(__FILE__) + '/../spec_helper'

describe 'TwitterTags' do
  dataset :pages

  describe '<r:twitter>' do
    it 'should require a twitter name in the name attribute' do
      tag = %{
        <r:twitter>
        </r:twitter>
      }
      
      pages(:home).should render(tag).with_error('the twitter-tag needs a username in the user attribute')
    end
    
    it 'should give no output' do
      tag = %{
        <r:twitter name='openminds_be'>
        </r:twitter>
      }
      expected = ''
      
      pages(:home).should render(tag).as(expected)      
    end
  end
  
  describe '<r:twitter:tweets>' do    
    it 'should give no output' do
      tag = %{
        <r:twitter user='openminds.be'>
          <r:tweets>
          </r:tweets>
        </r:twitter>
      }
      expected = ''

      pages(:home).should render(tag).as(expected)
    end
    
    it 'should honour the count attribute' do
      flunk
    end
    
    it 'should honour the order attribute' do
      flunk
    end
    
    it 'should give the last 10 tweets by default' do
      flunk
    end
  end
    
  describe '<r:twitter:tweets:tweet>' do
    it 'should give no output' do
      flunk
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
