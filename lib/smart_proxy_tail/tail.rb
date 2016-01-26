require 'logger'

module Proxy::Tail
  class Plugin < ::Proxy::Plugin
    plugin 'tail', Proxy::Tail::VERSION
    default_settings :pattern => '(ERR|Error|error|FATAL|fatal|Exception)', :poll => 1, :files => [['sys', '/var/log/messages']]

    after_activation do
      logger = ::Proxy::LogBuffer::Decorator.new(::Logger.new("/dev/null"))
      runner = Proxy::Tail::Runner.new(Proxy::Tail::Plugin.settings.pattern, Proxy::Tail::Plugin.settings.files, logger, Proxy::Tail::Plugin.settings.poll)
      runner.start
    end
  end
end
