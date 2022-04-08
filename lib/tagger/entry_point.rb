require 'tagger'

module Tagger
  module EntryPoint
    def self.call(args)
      cmd, command_name, args = Tagger::Resolver.call(args)
      Tagger::Executor.call(cmd, command_name, args)
    end
  end
end
