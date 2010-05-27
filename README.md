Haplocheirus Client

Haplocheirus is a highly available, partitioned storage service for
vectors of heterogenous blobs.


INSTALLATION
------------

    gem install haplocheirus-client


USAGE
-----

Attach a new client to a Haplo service:

    >> client = Haplocheirus.new # Defaults to localhost:7666

Store a vector under the id of '0':

    >> client.store '0', ['foo', 'bar']

Find the first 2 entries, starting at index 0:

    >> client.get '0', 0, 2
    ['bar', 'foo'] # note the reverse order

Append an entry:

    >> client.append '0', 'baz'
    >> client.get '0', 0, 3
    ['baz', 'bar', 'foo']

Merge that vector with another:

    >> client.merge '0', ['bat', 'quux']
    >> client.get '0', 0, 5
    ['quux', 'baz', 'bat', 'bar', 'foo']


Remove an entry:

    >> client.remove 'bat', '0'
    >> client.get '0', 0, 4
    ['quux', 'baz', 'bar', 'foo']

Remove a set of entries:

    >> client.unmerge '0' ['foo', 'bar']
    >> client.get '0', 0, 2
    ['quux', 'baz']

Delete the vector:
    >> client.delete '0'


CONTRIBUTORS
------------

Brandon Mitchell


LICENSE
-------

Copyright (C) 2010 Twitter, Inc.

This work is licensed under the Apache License, Version 2.0. See LICENSE for details.
