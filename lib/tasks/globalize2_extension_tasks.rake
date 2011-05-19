namespace :radiant do
  namespace :extensions do
    namespace :globalize2 do
      
      desc "Runs the migration of the Globalize2 extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          Globalize2Extension.migrator.migrate(ENV["VERSION"].to_i)
        else
          Globalize2Extension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Globalize2 to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from Globalize2Extension"
        Dir[Globalize2Extension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(Globalize2Extension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          cp file, RAILS_ROOT + path, :verbose => false
        end
      end

      desc "create language copies"
      task :copy_language => :environment do
        require 'highline/import'
        say "ERROR: Specify a SOURCE_LANG environment variable." and exit unless ENV['SOURCE_LANG']
        say "ERROR: Specify a DEST_LANG environment variable." and exit unless ENV['DEST_LANG']
        say "ERROR: Specify a SITE_ID environment variable." and exit unless ENV['SITE_ID']
        require 'pp'
        I18n.locale = ENV['SOURCE_LANG']
        %W{Page PagePart Snippet Layout Asset}.each do |model|
          puts "Translating #{model}"
          model_class = model.constantize
          objs = []
          if model_class.new.respond_to?(:site_id)
            objs = model_class.all(:conditions => {:site_id =>1})
          else
            objs = model_class.all
          end

          objs.each do |obj|
            begin
              I18n.locale = ENV['SOURCE_LANG'].to_sym
              puts "already translated locales: #{obj.translated_locales.join(', ')}"
              unless obj.translated_locales.include?(ENV['DEST_LANG'].to_sym) || obj.translated_locales.include?(ENV['DEST_LANG'])
                puts "translating #{model}: #{obj.id}"
                data = Hash.new
                puts "Translating attributes #{model_class.translated_attribute_names.join(",")}"
                model_class.translated_attribute_names.each do |attribute|
                  data[attribute] = obj.send(attribute) unless (obj.nil? || obj.send(attribute).empty?)
                end
                obj.set_translations(ENV['DEST_LANG'] => data)
                obj.save!
                puts "translated #{model}: #{obj.id}"
              end
            rescue Exception => e
              puts "failed to translate #{model}: #{obj.id}, cause: #{e}"
              pp data
            end
          end
        end
      end
    end
  end
end