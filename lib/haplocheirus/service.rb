class Haplocheirus::Service < ThriftClient
  DEFAULTS = { :transport_wrapper => Thrift::BufferedTransport }

  def initialize(servers = nil, options = {})
    if servers.nil? || servers.empty?
      servers = ['127.0.0.1:7666']
    else
      server = Array(servers)
    end

    super(Haplocheirus::TimelineStore::Client, servers, DEFAULTS.merge(options))
  end

end
