begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  retry
end

require 'haplocheirus'
require 'haplocheirus/mock_service'

# Useful to testing against a live haplo server.
def try_times(valid_proc, attempts = 5, &block)
  val = nil
  tries = 0
  loop do
    break if tries > attempts
    val = yield
    break if valid_proc.call(val)
    sleep 0.1
  end
  val
end
