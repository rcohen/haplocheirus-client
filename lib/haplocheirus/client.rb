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
  # prefix<String>:: Prefix to prepend to each id
  # timeline_ids<Array[Integer], Integer>
  #
  def append(entry, prefix, *timeline_ids)
    @service.append entry, prefix, timeline_ids.flatten
  end

  # Removes an entry from a set of timlines given by timeline_ids
  #
  # ==== Paramaters
  # entry
  # prefix<String>:: Prefix to prepend to each id
  # timeline_ids<Array[Integer]>
  #
  def remove(entry, prefix, timeline_ids)
    @service.remove entry, prefix, timeline_ids
  end

  # Gets entries on the timeline given by timeline_id, optionally
  # beginning at offset and limited by length. Timelines are stored in
  # recency order - an offset of 0 is the latest entry. Returns nil if
  # the timeline_id does not exist.
  #
  # ==== Parameters
  # timeline_id<String>
  # offset<Integer>
  # length<Integer>
  # dedupe<Boolean>:: Optional. Defaults to false.
  #
  # ==== Returns
  # TimelineSegment
  #
  # NOTE: The #size of the returned segment is computed *before* dupes
  # are removed.
  #
  def get(timeline_id, offset, length, dedupe = false)
    @service.get timeline_id, offset, length, dedupe
  rescue Haplocheirus::TimelineStoreException
    nil
  end

  # Gets a range of entries from the timeline given by timeline_id
  # since from_id (exclusive). This may include entries that were inserted out
  # of order. from_id and to_id are treated as a 8 byte prefixes. If
  # to_id is <= 0, results are not bounded by a maximum value. Returns
  # nil if the timeline_id does not exist.
  #
  # ==== Parameters
  # timeline_id<String>
  # from_id<Integer>
  # to_id<Integer>:: Optional. Defaults to 0.
  # dedupe<Integer>:: Optional. Defaults to false.
  #
  # ==== Returns
  # TimelineSegment
  #
  # NOTE: The #size of the returned segment is computed *before* dupes
  # are removed.
  #
  def range(timeline_id, from_id, to_id = 0, dedupe = false)
    @service.get_range timeline_id, from_id, to_id, dedupe
  rescue Haplocheirus::TimelineStoreException
    nil
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

  # Returns the intersection of entries with the current contents of
  # the timeline given by timeline_id. Returns nil if the
  # timeline_id does not exist.
  #
  # ==== Parameters
  # timeline_id<String>
  # entries<Array>
  #
  def filter(timeline_id, *entries)
    # FIXME: Expose max search depth
    @service.filter timeline_id, entries.flatten, -1
  rescue Haplocheirus::TimelineStoreException
    nil
  end

  # Merges the entries into the timeline given by timeline_id. Merges
  # will do nothing if the timeline hasn't been created using
  # #store. Entries should be byte arrays of at least 8B per entry.
  #
  # ==== Parameters
  # timeline_id<String>
  # entries<Array>
  #
  def merge(timeline_id, entries)
    @service.merge timeline_id, entries
  end

  # Merges entries in the timeline given by source_id into the
  # timeline given by dest_id. Does nothing if source_id does not exist.
  #
  # ==== Parameters
  # dest_id<String>
  # source_id<String>
  #
  def merge_indirect(dest_id, source_id)
    @service.merge_indirect dest_id, source_id
  end

  # Remove a list of entries from a timeline. Unmerges will do nothing
  # if the timeline hasn't been created using #store. Entries should
  # be byte arrays of at least 8B per entry.
  #
  # ==== Parameters
  # timeline_id<String>
  # entries<Array>
  #
  def unmerge(timeline_id, entries)
    @service.unmerge timeline_id, entries
  end

  # Removes entries in the timeline given by source_id from the
  # timeline given by dest_id. Does nothing if source_id does not exist.
  #
  # ==== Parameters
  # dest_id<String>
  # source_id<String>
  #
  def unmerge_indirect(dest_id, source_id)
    @service.unmerge_indirect dest_id, source_id
  end

  # Removes the timeline from the backend store
  #
  # ==== Parameters
  # timeline_id<String>
  #
  def delete(timeline_id)
    @service.delete_timeline timeline_id
  end
end
