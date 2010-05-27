begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  retry
end

require 'haplocheirus'

class Haplocheirus::MockService #:nodoc:

  def initialize
    @timelines = {}
  end

  def append(e, is)
    is.each do |i|
      next unless @timelines.key?(i)
      @timelines[i].push(e)
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
    @timelines[i][o..(o+l)]
  end

  def get_range(i, f = nil, t = nil)
    raise Thrift::ApplicationException unless @timelines.key?(i)
    return @timelines[i] unless f || t

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
    @timelines[i] = e
  end

  def merge(i, e)
    return unless @timelines.key?(i)
    @timelines[i].concat(e).sort!.uniq!
  end

  def unmerge(i, e)
    return unless @timelines.key?(i)
    @timelines[i].reject! { |i| e.include?(i) }
  end

  def delete(i)
    @timelines.delete(i)
  end
end
