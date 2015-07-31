require 'graphviz'

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
          attr[:color]     = 'red'
          attr[:style]     = 'filled'
          attr[:fillcolor] = 'red'
        when 'victim'
          attr[:fontname]  = 'bold'
          attr[:fontcolor] = 'white'
          attr[:color]     = 'gray'
          attr[:style]     = 'filled'
          attr[:fillcolor] = 'gray'
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
        attr[:color]     = 'red'
        attr[:fontcolor] = 'red'
      when 'friends'
        attr[:color]     = 'blue'
        attr[:fontcolor] = 'blue'
      when 'enemies'
        attr[:color]     = 'purple'
        attr[:fontcolor] = 'purple'
      else
      end
      attr
    end

    def add_edges
      # Override type to 'murder' if roles are right:
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
              _type           = 'murder'
              im_dead[player] = true
              ive_killed[id]  = true
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

    def output_png
      @g.output( :png => "#{@type}.png")
    end
  end
end
