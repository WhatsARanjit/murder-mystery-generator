require 'murder/util/setopts'
require 'murder/util/yaml'
require 'murder/world'
require 'murder/doc'

module MURDER
  module Action
    module Generate
      class Docs

        include MURDER::Util::Setopts
        include MURDER::Util::Yaml

        def initialize(opts, argv, cmd)
          @opts = opts
          if argv.length == 0
            @type = 'both'
          else
            @type = argv[0]
          end
          setopts(opts, {
            :config => :self,
            :trace  => :self,
          })

          # Setup defaults
          @pwd      = Dir.pwd
          @config ||= "#{@pwd}/game.yaml"
          @world    = MURDER::World.new(@config)
        end

        def call
          puts "= Generating docs for characters in \"#{@world.name}\""
          @characters = @world.mk_character_hash

          request_docs
        end

        def list_markdowns
          Dir["#{Dir.pwd}/markdown/*"]
        end

        def request_docs
          @characters.each do |id, hash|
            # Change link IDs to names
            ['enemies', 'friends'].each do |type|
              hash["_#{type}"] = Array.new
              hash[type].each do |person|
                hash["_#{type}"] << @world.get_name_from_id(person)
              end
            end
            char = MURDER::Doc.new('profile.md.erb', hash)
            # Create markdown files first so you can edit
            if @type == 'markdown' or @type == 'both'
              char.save_md
              puts "Created markdown for '#{@characters[id]['name']}'"
            end
            # Render the PDFs from markdown
            # Gives you a chance to edit markdown
            # manually to add details and theming.
            if @type == 'pdf' or @type == 'both'
              char.render_pdf(char.render_md)
              puts "Created PDF for '#{@characters[id]['name']}'"
            end
          end
        end
      end
    end
  end
end
