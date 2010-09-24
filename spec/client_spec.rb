require 'spec_helper'

describe Haplocheirus::Client do

  ARBITRARILY_LARGE_LIMIT = 100
  PREFIX = 'timeline:'

  before(:each) do
    @client  = Haplocheirus::Client.new(Haplocheirus::MockService.new)
  end

  describe 'append' do
    it 'works' do
      @client.store PREFIX + '0', ['bar']
      @client.append 'foo', PREFIX, [0]

      rval = @client.get(PREFIX + '0', 0, ARBITRARILY_LARGE_LIMIT)
      rval.entries.should == ['foo', 'bar']
      rval.size.should == 2
    end

    it 'supports single timeline ids' do
      @client.store PREFIX + '0', ['bar']
      @client.append 'foo', PREFIX, 0

      rval = @client.get(PREFIX + '0', 0, ARBITRARILY_LARGE_LIMIT)
      rval.entries.should == ['foo', 'bar']
      rval.size.should == 2
    end
  end

  describe 'remove' do
    it 'works' do
      @client.store PREFIX + '0', ['foo']
      @client.remove 'foo', PREFIX, [0]
      @client.get(PREFIX + '0', 0, ARBITRARILY_LARGE_LIMIT).should be_nil
    end
  end

  describe 'get' do
    it 'works' do
      @client.store '0', (1..20).map { |i| i.to_s }
      rval = @client.get('0', 0, ARBITRARILY_LARGE_LIMIT)
      rval.entries.should == (1..20).map { |i| i.to_s }
      rval.size.should == 20
    end

    it 'does not dedupe by default' do
      timeline = ["\004\000\000\000\000\000\000\000\003\000\000\000\000\000\000\000\000\000\000\200", # retweet - dupe
                  "\003\000\000\000\000\000\000\000\003\000\000\000\000\000\000\000\000\000\000\000", # tweet
                  "\002\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\000\200"] # retweet - not a dupe
      @client.store '0', timeline
      @client.get('0', 0, ARBITRARILY_LARGE_LIMIT).entries.should == timeline
    end

    it 'dedupes with source present' do
      timeline = ["\004\000\000\000\000\000\000\000\003\000\000\000\000\000\000\000\000\000\000\200", # retweet - dupe
                  "\003\000\000\000\000\000\000\000\003\000\000\000\000\000\000\000\000\000\000\000", # tweet
                  "\002\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\000\200"] # retweet - not a dupe
      @client.store '0', timeline
      @client.get('0', 0, ARBITRARILY_LARGE_LIMIT, true).entries.should == timeline[1,2]
    end

    it 'dedupes without source present' do
      timeline = ["\006\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\000\200", # retweet - dupe
                  "\005\000\000\000\000\000\000\000\003\000\000\000\000\000\000\000\000\000\000\200", # retweet - dupe
                  "\004\000\000\000\000\000\000\000\003\000\000\000\000\000\000\000\000\000\000\200", # retweet - dupe
                  "\002\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\000\200"] # retweet - not a dupe
      @client.store '0', timeline
      @client.get('0', 0, ARBITRARILY_LARGE_LIMIT, true).entries.should == timeline[2,3]
    end

    it 'returns nil on error' do
      @client.delete '0'
      @client.get('0', 0, ARBITRARILY_LARGE_LIMIT).should be_nil
    end
  end

  describe 'range' do
    it 'returns with a lower bound' do
      @client.store '0', (1..20).map { |i| [i].pack("Q") }.reverse
      rval = @client.range('0', 5)
      rval.entries.should == 20.downto(6).map { |i| [i].pack("Q") }
      rval.size.should == 20
    end

    it 'returns with an upper bound' do
      @client.store '0', (1..20).map { |i| [i].pack("Q") }.reverse
      rval = @client.range('0', 5, 10)
      rval.entries.should == 10.downto(6).map { |i| [i].pack("Q") }
      rval.size.should == 20
    end

    it 'does not dedupe by default' do
      timeline = ["\004\000\000\000\000\000\000\000\003\000\000\000\000\000\000\000\000\000\000\200", # retweet - dupe
                  "\003\000\000\000\000\000\000\000\003\000\000\000\000\000\000\000\000\000\000\000", # tweet
                  "\002\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\000\200"] # retweet - not a dupe
      @client.store '0', timeline
      @client.range('0', 0, 10).entries.should == timeline
    end

    it 'dedupes with source present' do
      timeline = ["\004\000\000\000\000\000\000\000\003\000\000\000\000\000\000\000\000\000\000\200", # retweet - dupe
                  "\003\000\000\000\000\000\000\000\003\000\000\000\000\000\000\000\000\000\000\000", # tweet
                  "\002\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\000\200"] # retweet - not a dupe
      @client.store '0', timeline
      @client.range('0', 0, 10, true).entries.should == timeline[1,2]
    end

    it 'dedupes without source present' do
      timeline = ["\006\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\000\200", # retweet - dupe
                  "\005\000\000\000\000\000\000\000\003\000\000\000\000\000\000\000\000\000\000\200", # retweet - dupe
                  "\004\000\000\000\000\000\000\000\003\000\000\000\000\000\000\000\000\000\000\200", # retweet - dupe
                  "\002\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\000\200"] # retweet - not a dupe
      @client.store '0', timeline
      @client.range('0', 0, 10, true).entries.should == timeline[2,3]
    end

    it 'slices before deduping'

    it 'returns nil on error' do
      @client.delete '0'
      @client.range('0', 5).should be_nil
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
      @client.store '0', ["\003\000\000\000\000\000\000\000", "\002\000\000\000\000\000\000\000"]
      @client.filter('0', "\003\000\000\000\000\000\000\000").should == ["\003\000\000\000\000\000\000\000"]
      @client.filter('0', ["\003\000\000\000\000\000\000\000"]).should == ["\003\000\000\000\000\000\000\000"]
    end

    it 'returns nil on error' do
      @client.delete '0'
      @client.filter('0', "\003\000\000\000\000\000\000\000").should be_nil
    end
  end

  describe 'merge' do
    it 'works' do
      @client.store '0', ["\003\000\000\000\000\000\000\000", "\001\000\000\000\000\000\000\000"]
      @client.merge '0', ["\002\000\000\000\000\000\000\000"]

      rval = @client.get('0', 0, ARBITRARILY_LARGE_LIMIT)
      rval.entries.should == ["\003\000\000\000\000\000\000\000",
                              "\002\000\000\000\000\000\000\000",
                              "\001\000\000\000\000\000\000\000"]
      rval.size.should == 3
    end
  end

  describe 'merge_indirect' do
    it 'works' do
      @client.store '0', ["\003\000\000\000\000\000\000\000", "\001\000\000\000\000\000\000\000"]
      @client.store '1', ["\002\000\000\000\000\000\000\000"]
      @client.merge_indirect '0', '1'

      rval = @client.get('0', 0, ARBITRARILY_LARGE_LIMIT)
      rval.entries.should == ["\003\000\000\000\000\000\000\000",
                              "\002\000\000\000\000\000\000\000",
                              "\001\000\000\000\000\000\000\000"]
      rval.size.should == 3
    end

    it 'no-ops for non-existing source' do
      @client.store '0', ['foo']
      @client.delete '1' # just in case
      @client.merge_indirect '0', '1'

      rval = @client.get('0', 0, ARBITRARILY_LARGE_LIMIT)
      rval.entries.should == ['foo']
      rval.size.should == 1
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

  describe 'unmerge_indirect' do
    it 'works' do
      @client.store '0', ['foo', 'bar', 'baz']
      @client.store '1', ['bar']
      @client.unmerge_indirect '0', '1'

      rval = @client.get('0', 0, ARBITRARILY_LARGE_LIMIT)
      rval.entries.should == ['foo', 'baz']
      rval.size.should == 2
    end

    it 'no-ops for non-existing source' do
      @client.store '0', ['foo']
      @client.delete '1' # just in case
      @client.unmerge_indirect '0', '1'

      rval = @client.get('0', 0, ARBITRARILY_LARGE_LIMIT)
      rval.entries.should == ['foo']
      rval.size.should == 1
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
