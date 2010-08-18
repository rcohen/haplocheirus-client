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

      rval = @client.get('0', 0, ARBITRARILY_LARGE_LIMIT)
      rval.entries.should == ['foo']
      rval.size.should == 1
    end

    it 'supports single timeline ids' do
      @client.store '0', []
      @client.append 'foo', '0'

      rval = @client.get('0', 0, ARBITRARILY_LARGE_LIMIT)
      rval.entries.should == ['foo']
      rval.size.should == 1
    end
  end

  describe 'remove' do
    it 'works' do
      @client.store '0', ['foo']
      @client.remove 'foo', ['0']

      rval = @client.get('0', 0, ARBITRARILY_LARGE_LIMIT)
      rval.entries.should == []
      rval.size.should == 0
    end
  end

  describe 'get' do
    it 'works' do
      @client.store '0', (1..20).to_a
      rval = @client.get('0', 0, ARBITRARILY_LARGE_LIMIT)
      rval.entries.should == (1..20).to_a
      rval.size.should == 20
    end

    it 'dedupes'

    it 'returns nil on error' do
      rval = @client.get('0', 0, ARBITRARILY_LARGE_LIMIT)
      rval.should be_nil
    end
  end

  describe 'range' do
    it 'returns with a lower bound' do
      @client.store '0', (1..20).to_a.reverse
      rval = @client.range('0', 5)
      rval.entries.should == 20.downto(6).to_a
      rval.size.should == 15
    end

    it 'returns with an upper bound' do
      @client.store '0', (1..20).to_a.reverse
      rval = @client.range('0', 5, 10)
      rval.entries.should == 10.downto(6).to_a
      rval.size.should == 5
    end

    it 'dedupes'

    it 'returns nil on error' do
      rval = @client.range('0', 5)
      rval.should be_nil
    end
  end

  describe 'store' do
    it 'works' do
      @client.store '0', ['foo']
      rval = @client.get('0', 0, ARBITRARILY_LARGE_LIMIT)
      rval.entries.should == ['foo']
      rval.size.should == 1
    end
  end

  describe 'filter' do
    it 'works' do
      @client.store '0', ['foo', 'bar']
      @client.filter('0', 'foo').should == ['foo']
      @client.filter('0', ['foo']).should == ['foo']
    end

    it 'returns an empty collection on error' do
      @client.filter('0', 'foo').should be_nil
    end
  end

  describe 'merge' do
    it 'works' do
      @client.store '0', ['foo', 'baz']
      @client.merge '0', ['bar']

      rval = @client.get('0', 0, ARBITRARILY_LARGE_LIMIT)
      rval.entries.should == ['foo', 'bar', 'baz']
      rval.size.should == 3
    end
  end

  describe 'unmerge' do
    it 'works' do
      @client.store '0', ['foo', 'bar', 'baz']
      @client.unmerge('0', ['bar'])

      rval = @client.get('0', 0, ARBITRARILY_LARGE_LIMIT)
      rval.entries.should == ['foo', 'baz']
      rval.size.should == 2
    end
  end

  describe 'delete' do
    it 'works' do
      @client.store '0', ['foo']
      @client.delete '0'
      @client.get('0', 0, ARBITRARILY_LARGE_LIMIT).should be_nil
    end
  end

end
