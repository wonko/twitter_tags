# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'
require 'twitter'

class TwitterTagsExtension < Radiant::Extension
  version "1.0"
  description "Getting tweets from certain accounts in your website"
  url "http://www.openminds.be/twitter_tags"
  
  # define_routes do |map|
  #   map.namespace :admin, :member => { :remove => :get } do |admin|
  #     admin.resources :twitter_tags
  #   end
  # end
  
  def activate
    Page.send :include, TwitterTags
    # admin.tabs.add "Twitter Tags", "/admin/twitter_tags", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    # admin.tabs.remove "Twitter Tags"
  end
  
end
