require 'set'

class Haplocheirus::MockService #:nodoc:

  def initialize
    @timelines = {}
  end

  def append(e, is)
    is.each do |i|
      next unless @timelines.key?(i)
      @timelines[i] << e
    end
  end

  def remove(e, is)
    is.each do |i|
      next unless @timelines.key?(i)
      @timelines[i].reject! { |i| i == e }
    end
  end

  def get(i, o, l, d = false)
    raise Thrift::ApplicationException unless @timelines.key?(i)
    @timelines[i].to_a[o..(o+l)]
  end

  def get_since(i, f, d = false)
    raise Thrift::ApplicationException unless @timelines.key?(i)
    index = @timelines[i].index(f)
    index ? @timelines[i][0..index-1] : @timelines[i]
  end

  def store(i, e)
    @timelines[i] ||= []
    e.each { |n| append n, [i] }
  end

  def filter(i, *e)
    raise Thrift::ApplicationException unless @timelines.key?(i)
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

  def unmerge(i, e)
    return unless @timelines.key?(i)
    @timelines[i].reject! { |i| e.include?(i) }
  end

  def delete(i)
    @timelines.delete(i)
  end
end
