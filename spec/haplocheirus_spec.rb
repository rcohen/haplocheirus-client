require 'spec_helper'

describe Haplocheirus do

  describe 'new' do
    it 'returns an instance of H::Client' do
      h = Haplocheirus.new
      h.should_not be_nil
      h.should be_an_instance_of Haplocheirus::Client
    end

    it 'returns nil when :enabled is false' do
      Haplocheirus.new('localhost:7666', :enabled => false).should be_nil
    end
  end

end
