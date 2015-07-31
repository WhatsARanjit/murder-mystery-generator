require 'murder/cli'
require 'murder/action/graph'
require 'cri'

module MURDER::CLI
  module Graph
    def self.command
      @cmd ||= Cri::Command.define do
        name    'graph'
        usage   'graph <elements>'
        summary 'Create murder graphs'

        description <<-DESCRIPTION
`murder graph` provides a visual setup of a game.
Elements to be drawn include enemies and/or friends.
This will default to both.
        DESCRIPTION

        required :c, :config, 'Specify a configuration file'

        runner MURDER::Action::Graph
        #run do |opts, args, cmd|
        #  puts cmd.help(:verbose => opts[:verbose])
        #  exit 0
        #end
      end
    end

    #module Friends
    #  def self.command
    #    @cmd ||= Cri::Command.define do
    #      name    'friends'
    #      usage   'friends'
    #      summary 'Graphs all friendly relationships'

    #      runner MURDER::Action::Graph::Friends
    #    end
    #  end
    #end
  end
end

MURDER::CLI.command.add_command(MURDER::CLI::Graph.command)
#MURDER::CLI::Graph.command.add_command(MURDER::CLI::Graph::Friends.command)
