class Haplocheirus::Client

  # ==== Parameters
  # service<ThriftClient>
  #
  def initialize(service)
    @service = service
  end

  # Appends an entry to a set of timelines given by
  # timeline_ids. Appends will do nothing if the timeline has not been
  # created using #store.
  #
  # ==== Parameters
  # entry
  # timeline_ids<Array[String]>
  #
  def append(entry, timeline_ids)
    @service.append entry, timeline_ids
  end

  # Removes an entry from a set of timlines given by timeline_ids
  #
  # ==== Paramaters
  # entry
  # timeline_ids<Array[String]>
  #
  def remove(entry, timeline_ids)
    @service.remove entry, timeline_ids
  end

  # Gets entries on the timeline given by timeline_id, optionally
  # beginning at offset and limited by length. Timelines are stored in
  # recency order - an offset of 0 is the latest entry.
  #
  # ==== Parameters
  # timeline_id<String>
  # offset<Integer>
  # length<Integer>
  #
  def get(timeline_id, offset, length)
    @service.get timeline_id, offset, length
  rescue Thrift::ApplicationException
    []
  end

  # Gets a range of entries from the timeline given by timeline_id
  # between from_id (exclusive) and to_id (inclusive). This may
  # include entries with a lower or higher id that were inserted out
  # of order. Both from_id and to_id are treated as prefixes.
  #
  # ==== Parameters
  # timeline_id<String>
  # from_id<Integer>:: Optional
  # to_id<Integer>:: Optional
  #
  def get_range(timeline_id, from_id = nil, to_id = nil)
    @service.get_range timeline_id, from_id, to_id
  rescue Thrift::ApplicationException => e
    []
  end

  # Atomically stores a set of entries into a timeline given by
  # timeline_id. The entries are stored in the order provided.
  #
  # ==== Parameters
  # timeline_id<String>
  # entries<Array>
  #
  def store(timeline_id, entries)
    @service.store timeline_id, entries
  end

  # Merges the entries into the timeline given by timeline_id. Merges
  # will do nothing if the timeline hasn't been created using #store.
  #
  # ==== Parameters
  # timeline_id<String>
  # entries<Array>
  #
  def merge(timeline_id, entries)
    @service.merge timeline_id, entries
  end

  # Remove a list of entries from a timeline. Unmerges will do nothing
  # if the timeline hasn't been created using #store.
  #
  # ==== Parameters
  # timeline_id<String>
  # entries<Array>
  #
  def unmerge(timeline_id, entries)
    @service.unmerge timeline_id, entries
  end

  # Removes the timeline from the backend store
  #
  # ==== Parameters
  # timeline_id<String>
  #
  def delete(timeline_id)
    @service.delete timeline_id
  end
end
