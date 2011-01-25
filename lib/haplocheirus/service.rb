class Haplocheirus::Service < ThriftClient
  DEFAULTS = { :transport_wrapper => Thrift::BufferedTransport }

  class ServiceDisabled < StandardError; end

  def initialize(servers = nil, options = {})
    raise ServiceDisabled if options.key?(:enabled) && !options[:enabled]

    if servers.nil? || servers.empty?
      servers = ['127.0.0.1:7666']
    else
      server = Array(servers)
    end

    super(Haplocheirus::TimelineStore::Client, servers, DEFAULTS.merge(options))
  end

end
