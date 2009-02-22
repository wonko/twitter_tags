namespace :radiant do
  namespace :extensions do
    namespace :twitter_tags do
      
      desc "Runs the migration of the Twitter Tags extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          TwitterTagsExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          TwitterTagsExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Twitter Tags to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from TwitterTagsExtension"
        Dir[TwitterTagsExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(TwitterTagsExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
