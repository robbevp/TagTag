require 'tagger'

module Tagger
  module Help

    def self.generate(path, to: STDOUT)
      case path.size
      when 0
        generate_toplevel(to: to)
      when 1
        generate_command_help(path.first, to: to)
      else
        raise(NotImplementedError, 'subcommand help not implemented')
      end
    end

    def self.generate_toplevel(to: STDOUT)
      to.write(CLI::UI.fmt(<<~HELP))
        {{bold:{{command:#{TOOL_NAME}}} inspects the contents of audio files.}}
        It basically only has one command: {{command:#{TOOL_NAME} inspect}}.
        See {{command:#{TOOL_NAME} inspect --help}} for more information.
      HELP

      cmds = Tagger::Commands::Registry.resolved_commands.map do |name, klass|
        [name, klass._desc]
      end

      max_len = cmds.map(&:first).map(&:length).max

      cmds.each do |name, desc|
        to.write(CLI::UI.fmt("  {{command:#{name.ljust(max_len)}}}  #{desc}\n"))
      end
    end

    def self.generate_command_help(cmd_name, to: STDOUT)
      klass = Tagger::Commands::Registry.resolved_commands[cmd_name]
      unless klass
        to.write(CLI::UI.fmt(<<~HELP))
          {{red:{{bold:No help found for: #{cmd_name}}}}}
        HELP
        generate_toplevel(to: to)
        raise(CLI::Kit::AbortSilent)
      end

      klass.new.call(['--help'], cmd_name)
    end
  end
end