class Haplocheirus::Service < ThriftClient

  def initialize(servers = nil, options = {})
    if servers.nil? || servers.empty?
      servers = ['127.0.0.1:7666']
    else
      server = Array(servers)
    end

    super Haplocheirus::TimelineStore::Client, servers, options
  end

end
