require 'spec_helper'

describe Haplocheirus::Client do

  ARBITRARILY_LARGE_LIMIT = 100

  before(:each) do
    @client  = Haplocheirus::Client.new(Haplocheirus::MockService.new)
  end

  describe 'append' do
    it 'works' do
      @client.store '0', []
      @client.append 'foo', ['0']

      @client.get('0', 0, ARBITRARILY_LARGE_LIMIT).should == ['foo']
    end

    it 'supports single timeline ids' do
      @client.store '0', []
      @client.append 'foo', '0'

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

    it 'dedupes'

    it 'returns an empty collection on error' do
      @client.get('0', 0, ARBITRARILY_LARGE_LIMIT).should be_empty
    end
  end

  describe 'range' do
    it 'returns with a lower bound' do
      @client.store '0', (1..20).to_a.reverse
      @client.range('0', 5).should == 20.downto(6).to_a
    end

    it 'returns with an upper bound' do
      @client.store '0', (1..20).to_a.reverse
      @client.range('0', 5, 10).should == 10.downto(6).to_a
    end

    it 'dedupes'

    it 'returns an empty collection on error' do
      @client.range('0', 5).should be_empty
    end
  end

  describe 'store' do
    it 'works' do
      @client.store '0', ['foo']
      @client.get('0', 0, ARBITRARILY_LARGE_LIMIT).should == ['foo']
    end
  end

  describe 'filter' do
    it 'works' do
      @client.store '0', ['foo', 'bar']
      @client.filter('0', 'foo').should == ['foo']
      @client.filter('0', ['foo']).should == ['foo']
    end

    it 'returns an empty collection on error' do
      @client.filter('0', 'foo').should == []
    end
  end

  describe 'merge' do
    it 'works' do
      @client.store '0', ['foo', 'baz']
      @client.merge '0', ['bar']
      @client.get('0', 0, ARBITRARILY_LARGE_LIMIT).should == ['foo', 'bar', 'baz']
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
