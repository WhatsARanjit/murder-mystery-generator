require 'murder/cli'
require 'murder/action/rename'
require 'cri'

module MURDER::CLI
  module Rename
    def self.command
      @cmd ||= Cri::Command.define do
        name    'rename'
        usage   'generate <old name> <new name>'
        summary 'Rename a player'

        description <<-DESCRIPTION
`murder rename` allows you to rename an existing player.
        DESCRIPTION

        runner MURDER::Action::Rename
      end
    end
  end
end

MURDER::CLI.command.add_command(MURDER::CLI::Rename.command)
