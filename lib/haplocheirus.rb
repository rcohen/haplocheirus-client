begin
  require 'thrift'
  require 'thrift_client'
rescue LoadError
  require 'rubygems'
  retry
end

require 'haplocheirus/thrift/timeline_store'
require 'haplocheirus/service'
require 'haplocheirus/client'

module Haplocheirus
  autoload :MockService, 'haplocheirus/mock_service'

  # Convenience method for:
  #
  #    s = Haplocheirus::Service.new(*args)
  #    Haplocheirus::Client.new(s)
  #
  def self.new(*args)
    service = Haplocheirus::Service.new(*args)
    Haplocheirus::Client.new(service)
  rescue Haplocheirus::Service::ServiceDisabled
    nil
  end

end
