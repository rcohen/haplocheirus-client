begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  retry
end

require 'set'
require 'haplocheirus'

class Haplocheirus::MockService #:nodoc:

  def initialize
    @timelines = {}
  end

  def append(e, is)
    is.each do |i|
      next unless @timelines.key?(i)
      @timelines[i].add(e)
    end
  end

  def remove(e, is)
    is.each do |i|
      next unless @timelines.key?(i)
      @timelines[i].reject! { |i| i == e }
    end
  end

  def get(i, o, l)
    raise Thrift::ApplicationException unless @timelines.key?(i)
    @timelines[i].to_a[o..(o+l)]
  end

  def get_range(i, f = nil, t = nil)
    raise Thrift::ApplicationException unless @timelines.key?(i)
    return @timelines[i].to_a unless f || t

    r = []
    @timelines[i].each do |i|
      if f && t
        r << i if i > f && i <= t
      elsif f
        r << i if i > f
      elsif t
        r << i if i < t
      end
    end

    r
  end

  def store(i, e)
    @timelines[i] ||= SortedSet.new
    e.each { |n| append n, [i] }
  end

  def merge(i, e)
    return unless @timelines.key?(i)
    @timelines[i].merge(e)
  end

  def unmerge(i, e)
    return unless @timelines.key?(i)
    @timelines[i].reject! { |i| e.include?(i) }
  end

  def delete(i)
    @timelines.delete(i)
  end
end
