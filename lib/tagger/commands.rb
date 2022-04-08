require 'tagger'

module Tagger
  module Commands
    Registry = CLI::Kit::CommandRegistry.new(default: 'help')

    def self.register(const, cmd, path, lamda_const)
      autoload(const, path)
      Registry.add(lamda_const, cmd)
    end

    register :Help, 'help', 'tagger/commands/help', -> { Commands::Help }
    register :Inspect, 'inspect', 'tagger/commands/inspect', -> { Commands::Inspect }

    Registry.add_alias('-h', 'help')
    Registry.add_alias('--help', 'help')
  end
end
