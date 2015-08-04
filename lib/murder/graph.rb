require 'graphviz'
require 'yaml'

module MURDER
  class Graph

    def initialize(
      world,
      character_hash,
      roles = false,
      type = 'all'
      )
      @world      = world
      @characters = character_hash
      @roles      = roles
      @type       = type
      if type == 'all' 
        @lines    = [
        'friends',
        'enemies',
        ]
      else
        if type.is_a?String
          @lines = [type]
        else
          @lines = type
        end
      end
      create_graph_dir
    end

    def graph_defaults
      @g = GraphViz.new(
        :G,
        :strict        => true,
        :type          => :digraph,
        :rankdir       => 'LR',
        :label         => @world.name,
        :labelloc      => 't',
      )
      @g.node[:shape]  = 'box'
      @g.node[:color]  = 'black'

      @g.edge[:color]  = 'black'
      @g.edge[:weight] = '1'
      @g.edge[:style]  = 'filled'
      @g.edge[:label]  = ''
    end

    def cleanup_name(dirty)
      dirty.gsub(/[\s\-]/, '_').downcase
    end

    def get_name_from_id(qid)
      @characters[qid]['name']
    end

    def add_nodes
      @characters.each do |id, hash|
        attr = { :label => hash['name'] }
        case hash['role']
        when 'murderer'
          attr[:fontname]  = 'bold'
          attr[:fontcolor] = 'white'
          attr[:color]     = '#B80000'
          attr[:style]     = 'filled'
          attr[:fillcolor] = '#B80000'
        when 'victim'
          attr[:fontname]  = 'bold'
          attr[:fontcolor] = 'white'
          attr[:color]     = '#666699'
          attr[:style]     = 'filled'
          attr[:fillcolor] = '#666699'
        when 'poisoner'
          attr[:fontname]  = 'bold'
          attr[:fontcolor] = 'white'
          attr[:color]     = '#538A1C'
          attr[:style]     = 'filled'
          attr[:fillcolor] = '#538A1C'
        else
        end
        node = @g.add_node(
          cleanup_name(hash['name']),
          attr,
        )
        instance_variable_set("@#{cleanup_name(hash['name'])}", node)
      end
    end

    def edge_attrs(type)
      attr = { :label => type }
      case type
      when 'murder'
        attr[:color]     = '#B80000'
        attr[:fontcolor] = '#B80000'
      when 'friends'
        attr[:color]     = '#0000FF'
        attr[:fontcolor] = '#0000FF'
      when 'enemies'
        attr[:color]     = '#660066'
        attr[:fontcolor] = '#660066'
      when 'poison'
        attr[:color]     = '#538A1C'
        attr[:fontcolor] = '#538A1C'
      else
      end
      attr
    end

    def add_edges
      # Override type to 'murder' if roles are right:
      @tracker   = {
        'murder' => {},
        'poison' => {},
      }
      im_dead    = Hash.new
      ive_killed = Hash.new
      @roles['victim'].each do |id|
        @characters[id]['enemies'].each do |player|
          # If this enemy is the murderer, it's murder
          # and he gets a kill
          if @roles['murderer'].include?(player)
            _type              = 'murder'
            ive_killed[player] = true

            killer = cleanup_name( get_name_from_id(player) )
            @g.add_edges(
              killer,
              cleanup_name(@characters[id]['name']),
              edge_attrs(_type),
            )
            @tracker['murder'][player] = id
          end
        end
      end
      @characters.each do |id, hash|
        @lines.each do |type|
          hash[type].each do |player|
            if @roles['murderer'].include?(id) and
              (
                @roles['murderer'].include?(player) and
                ! im_dead[player] and
                ! ive_killed[id]
              )
              _type                  = 'murder'
              im_dead[player]        = true
              ive_killed[id]         = true
              @tracker['murder'][id] = player
            # If you are a poisoner who hasn't poisoned yet
            # and you can't poison a victim or murderer
            elsif @roles['poisoner'].include?(id) and
              ! @tracker['poison'][id] and
              ! @roles['victim'].include?(player)
              ! @roles['murderer'].include?(player)
              _type                  = 'poison'
              @tracker['poison'][id] = player
            else
              _type = type
            end
            target = cleanup_name( get_name_from_id(player) )
            @g.add_edges(
              cleanup_name(hash['name']),
              target,
              edge_attrs(_type),
            )
          end
        end
      end
    end

    def write_links_cache
      File.open('graphs/cache.yaml', 'w') do|file|
        file.write(@tracker.to_yaml)
      end
    end

    def create_graph_dir
      dir = "#{Dir.pwd}/graphs"
      puts "== Graph directory #{dir}" if
      (
        Dir.mkdir dir unless File.exists?(dir)
      )
    end

    def output_png
      @g.output( :png => "graphs/#{@type}.png")
      write_links_cache
    end
  end
end
