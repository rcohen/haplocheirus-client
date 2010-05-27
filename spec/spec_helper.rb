begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  retry
end

require 'haplocheirus'
require 'haplocheirus/mock_service'
