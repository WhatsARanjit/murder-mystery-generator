require 'murder/cli'
require 'murder/action/player'
require 'cri'

module MURDER::CLI
  module Player
    def self.command
      @cmd ||= Cri::Command.define do
        name    'player'
        usage   'player <subcommand> <arguments>'
        summary 'Rename a player'

        description <<-DESCRIPTION
`murder player` allows you to manipulate a existing players.
        DESCRIPTION

        run do |opts, args, cmd|
          puts cmd.help(:verbose => opts[:verbose])
          exit 0
        end
      end
    end

    module List
      def self.command
        @cmd ||= Cri::Command.define do
          name    'list'
          usage   'list'
          summary 'List all characters\' IDs and names'

          runner MURDER::Action::Player::List
        end
      end
    end
  end
end

MURDER::CLI.command.add_command(MURDER::CLI::Player.command)
MURDER::CLI::Generate.command.add_command(MURDER::CLI::Player::List.command)
