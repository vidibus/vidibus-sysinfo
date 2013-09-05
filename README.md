# Vidibus::Sysinfo

Allows reading various system information.

This gem is part of the open source service-oriented {video framework}[http://vidibus.org] Vidibus.


## Installation

Add the dependency to the Gemfile of your application:

```ruby
  gem "vidibus-sysinfo"
```

Then call bundle install on your console.


## System requirements

This gem uses various tools to obtain system data. Installing those tools should be simple, at least on Debian and Ubuntu:

```shell
  apt-get install sysstat vnstat lscpu
  vnstat -u -i eth0
  /etc/init.d/vnstat start
```

## Usage

### CPU cores

To get the number of CPU cores, call

```ruby
  Vidibus::Sysinfo.core
  # => 4
```

### CPU utilization

To get CPU utilization in percent, call

```ruby
  Vidibus::Sysinfo.cpu
  # => 18.4 # percent
```

### System load

The system load value is divided by the number of CPU cores.
To get the system load, call

```ruby
  Vidibus::Sysinfo.load
  # => 0.39
```

### Monthly traffic

To get the total traffic of this month in gigabytes, call

```ruby
  Vidibus::Sysinfo.traffic
  # => 7992.15 # gigabytes
```

### Currently used bandwidth

To get the currently used bandwidth in MBit/s, call

```ruby
  Vidibus::Sysinfo.bandwidth
  # => 38.71 # MBit/s
```

Bandwidth detection is performed by analyzing the output of /proc/net/dev.
To get the amount of traffic in a certain timespan, the analyzer gets
called twice and the delta of the two results is the traffic.

By default, bandwidth detection only waits one second, thus the results
will be quite volatile. To get a more accurate result, you can provide
an optional argument:

```ruby
  Vidibus::Sysinfo.bandwidth(10)
  # => 33.28 # MBit/s
```

### Consumed storage

To get the consumed storage of the main device in gigabytes, call

```ruby
  Vidibus::Sysinfo.storage
  # => 647.89 # gigabytes
```

### Used memory

To get the currently used memory in megabytes, call

```ruby
  Vidibus::Sysinfo.memory
  # => 3281.38 # megabytes
```

This will ignore memory used for system caching.


### Used swap

To get the currently used swap in megabytes, call

```ruby
  Vidibus::Sysinfo.swap
  # => 0.0 # megabytes
```

## Copyright

Copyright (c) 2011-2013 Andre Pankratz. See LICENSE for details.
