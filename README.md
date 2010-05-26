Haplocheirus Client

Haplocheirus is a highly available, partitioned storage service for
vectors of heterogenous blobs.


INSTALLATION
------------

    gem install haplocheirus-client


USAGE
-----

Attach a new client to a Haplo service:

    >> include Haplocheirus
    >> haplo  = Service.new # Defaults to localhost:7666
    >> client = Client.new haplo

Store a vector under the id of '0':

    >> client.store '0', ['foo', 'bar']
    >> client.get '0'
    ['foo', 'bar']

Append an entry:

    >> client.append '0', 'baz'
    >> client.get '0'
    ['foo', 'bar', 'baz']

Merge that vector with another:

    >> client.merge '0', ['bat', 'quux']
    >> client.get '0'
    ['foo', 'bar', 'bat', 'baz', 'quux']

Find the first 2 entries:

    >> client.get '0', 0, 2
    ['foo', 'bar']

Remove an entry:

    >> client.remove 'bat', '0'
    >> client.get '0'
    ['foo', 'bar', 'baz', 'quux']

Remove a set of entries:

    >> client.unmerge '0' ['foo', 'bar']
    >> client.get '0'
    ['baz', 'quux']

Delete the vector:
    >> client.delete '0'


CONTRIBUTORS
------------

Brandon Mitchell


LICENSE
-------

Copyright (C) 2010 Twitter, Inc.

This work is licensed under the Apache License, Version 2.0. See LICENSE for details.
