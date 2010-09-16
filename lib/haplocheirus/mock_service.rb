require 'set'

class Haplocheirus::MockService #:nodoc:

  class MockResult < Struct.new(:entries, :size)
  end

  def initialize
    @timelines = {}
  end

  def append(e, p, is)
    is.each do |i|
      next unless @timelines.key?(p + i.to_s)
      @timelines[p + i.to_s].unshift(e)
    end
  end

  def remove(e, p, is)
    is.each do |i|
      key = p + i.to_s
      next unless @timelines.key?(key)
      @timelines[key].reject! { |i| i == e }
      @timelines.delete(key) if @timelines[key].empty?
    end
  end

  def get(i, o, l, d = false)
    raise Haplocheirus::TimelineStoreException unless @timelines.key?(i)
    t = @timelines[i].to_a[o..(o+l)]
    MockResult.new t, t.length
  end

  def get_range(i, f, t = 0, d = false)
    raise Haplocheirus::TimelineStoreException unless @timelines.key?(i)
    min = @timelines[i].index([f].pack("Q"))
    max = t > 0 ? @timelines[i].index([t].pack("Q")) : 0
    t = min ? @timelines[i][max..min-1] : @timelines[i]
    MockResult.new t, @timelines[i].length
  end

  def store(i, e)
    @timelines[i] ||= []
    e.reverse.each { |n| append n, '', [i] }
  end

  def filter(i, *e)
    raise Haplocheirus::TimelineStoreException unless @timelines.key?(i)
    @timelines[i] & e.flatten
  end

  def merge(i, e)
    return unless @timelines.key?(i)

    e.each do |el|
      o = 0
      o += 1 while @timelines[i][0] <= el
      @timelines[i].insert(o + 1, el)
    end
  end

  def merge_indirect(d, s)
    merge(d, @timelines[s]) if @timelines.key?(s)
  end

  def unmerge(i, e)
    return unless @timelines.key?(i)
    @timelines[i].reject! { |i| e.include?(i) }
  end

  def unmerge_indirect(d, s)
    unmerge(d, @timelines[s]) if @timelines.key?(s)
  end

  def delete_timeline(i)
    @timelines.delete(i)
  end

  # This is not part of Haplo, but is useful for test harnesses
  def reset!
    @timelines = {}
  end
end
