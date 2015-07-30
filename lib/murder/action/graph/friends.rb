require 'murder/util/setopts'
require 'murder/world'
require 'murder/graph'
require 'pry'

module MURDER
  module Action
    module Graph
      class Friends

        include MURDER::Util::Setopts

        def initialize(opts, argv, cmd)
          @opts = opts
          @argv = argv
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
          puts "= Generating friends graph for \"#{@world.name}\""

          @characters = @world.mk_character_hash
          g = MURDER::Graph.new(@characters, send_roles)
          g.graph_defaults
          g.add_nodes
          g.add_edges
          g.output_png
        end

        # Graph needs to know murderers/victims
        def send_roles
          s_roles = Hash.new
          @world.roles.keys.each do |role|
            s_roles[role] = @world.role_lookup(role)
          end
          s_roles
        end
      end
    end
  end
end
