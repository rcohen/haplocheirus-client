require 'thrift'
require 'thrift_client'

require 'haplocheirus/thrift/timeline_store'
require 'haplocheirus/service'
require 'haplocheirus/client'

module Haplocheirus

  # Convenience method for:
  #
  #    s = Haplocheirus::Service.new(*args)
  #    Haplocheirus::Client.new(s)
  #
  def self.new(*args)
    service = Haplocheirus::Service.new(*args)
    Haplocheirus::Client.new(service)
  end

end
