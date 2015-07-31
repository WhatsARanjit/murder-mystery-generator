require 'murder/cli'
require 'murder/action/player'
require 'cri'

module MURDER::CLI
  module Player
    def self.command
      @cmd ||= Cri::Command.define do
        name    'player'
        usage   'player <subcommand> <arguments>'
        summary 'Set/get player attributes'

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

    module Attr
      def self.command
        @cmd ||= Cri::Command.define do
          name    'attr'
          usage   'attr'
          summary 'List one character\'s attributes'

          runner MURDER::Action::Player::Attr
        end
      end
    end

    module Getid
      def self.command
        @cmd ||= Cri::Command.define do
          name    'getid'
          usage   'getid <player name>'
          summary 'Get a player\'s ID from their name'

          runner MURDER::Action::Player::Getid
        end
      end
    end
  end
end

MURDER::CLI.command.add_command(MURDER::CLI::Player.command)
MURDER::CLI::Player.command.add_command(MURDER::CLI::Player::List.command)
MURDER::CLI::Player.command.add_command(MURDER::CLI::Player::Attr.command)
MURDER::CLI::Player.command.add_command(MURDER::CLI::Player::Getid.command)
