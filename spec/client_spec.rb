require 'spec_helper'

describe Haplocheirus::Client do

  ARBITRARILY_LARGE_LIMIT = 100

  before(:each) do
    @service = Haplocheirus::MockService.new
    @client  = Haplocheirus::Client.new @service
  end

  describe 'append' do
    it 'works' do
      @client.store '0', []
      @client.append 'foo', ['0']

      @client.get('0', 0, ARBITRARILY_LARGE_LIMIT).should == ['foo']
    end
  end

  describe 'remove' do
    it 'works' do
      @client.store '0', ['foo']
      @client.remove 'foo', ['0']

      @client.get('0', 0, ARBITRARILY_LARGE_LIMIT).should == []
    end
  end

  describe 'get' do
    it 'works' do
      @client.store '0', (1..20).to_a
      @client.get('0', 0, ARBITRARILY_LARGE_LIMIT).should == (1..20).to_a
    end

    it 'returns an empty collection on error' do
      @client.get('0', 0, ARBITRARILY_LARGE_LIMIT).should be_empty
    end
  end

  describe 'get_range' do
    it 'works' do
      @client.store '0', (1..20).to_a

      @client.get_range('0').should == (1..20).to_a
      @client.get_range('0', 5).should == (6..20).to_a
      @client.get_range('0', 5, 15).should == (6..15).to_a
    end

    it 'returns an empty collection on error' do
      @client.get_range('0').should be_empty
    end
  end

  describe 'store' do
    it 'works' do
      @client.store '0', ['foo']
      @client.get('0', 0, ARBITRARILY_LARGE_LIMIT).should == ['foo']
    end
  end

  describe 'merge' do
    it 'works' do
      @client.store '0', ['foo', 'baz']
      @client.merge '0', ['bar']
      @client.get('0', 0, ARBITRARILY_LARGE_LIMIT).should == ['bar', 'baz', 'foo']
    end
  end

  describe 'unmerge' do
    it 'works' do
      @client.store '0', ['foo', 'bar', 'baz']
      @client.unmerge('0', ['bar'])
      @client.get('0', 0, ARBITRARILY_LARGE_LIMIT).should == ['foo', 'baz']
    end
  end

  describe 'delete' do
    it 'works' do
      @client.store '0', ['foo']
      @client.delete '0'
      @client.get('0', 0, ARBITRARILY_LARGE_LIMIT).should == []
    end
  end

end
