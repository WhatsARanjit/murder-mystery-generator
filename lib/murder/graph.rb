require 'graphviz'

module MURDER
  class Graph

    def initialize(
      character_hash,
      type = 'all'
      )
      @characters = character_hash
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
        :type    => :digraph,
        :rankdir => 'LR'
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
      when 'friends'
        attr[:color] = 'blue'
      when 'enemies'
        attr[:color] = 'purple'
      else
      end
      attr
    end

    def add_edges
      @characters.each do |id, hash|
        @lines.each do |type|
          hash[type].each do |player|
            target = cleanup_name( get_name_from_id(player) )
            @g.add_edges(
              cleanup_name(hash['name']),
              target,
              edge_attrs(type),
            )
          end
        end
      end
    end

    def output_png
      @g.output( :png => 'friends.png')
    end
  end
end
