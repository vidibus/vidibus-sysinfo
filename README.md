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
  apt-get install sysstat vnstat
  vnstat -u -i eth0
  /etc/init.d/vnstat start
```

## Usage

### CPU cores

To get general system information, call

```ruby
  Vidibus::Sysinfo.system.to_h    # following metrics as hash

  Vidibus::Sysinfo.system.cpus    # number of CPUs
  Vidibus::Sysinfo.system.cores   # number of cores
  Vidibus::Sysinfo.system.sockets # number of sockets
```

### CPU utilization

To get CPU utilization in percent, call

```ruby
  Vidibus::Sysinfo.cpu.to_f   # usage total
  Vidibus::Sysinfo.cpu.to_i   # rounded usage total
  Vidibus::Sysinfo.cpu.to_h   # following metrics as hash

  Vidibus::Sysinfo.cpu.used   # usage total
  Vidibus::Sysinfo.cpu.idle   # idle
  Vidibus::Sysinfo.cpu.user   # on user level
  Vidibus::Sysinfo.cpu.nice   # with nice priority
  Vidibus::Sysinfo.cpu.system # on system level
  Vidibus::Sysinfo.cpu.iowait # waiting for IO
  Vidibus::Sysinfo.cpu.irq    # caused by service interrupts
  Vidibus::Sysinfo.cpu.soft   # caused by software interrupts
  Vidibus::Sysinfo.cpu.steal  # caused by virtualization hypervisor
  Vidibus::Sysinfo.cpu.guest  # on virtual processors
```

### System load

The system load value is divided by the number of CPU cores.
To get the system load, call

```ruby
  Vidibus::Sysinfo.load.to_f    # system load over last minute
  Vidibus::Sysinfo.load.to_h    # following metrics as hash

  Vidibus::Sysinfo.load.one     # system load over last minute
  Vidibus::Sysinfo.load.five    # system load over five minutes
  Vidibus::Sysinfo.load.fifteen # system load over fifteen minutes
```

### Monthly traffic

To get the total traffic of this month in gigabytes, call

```ruby
  Vidibus::Sysinfo.traffic.to_f   # traffic total
  Vidibus::Sysinfo.traffic.to_i   # rounded traffic total
  Vidibus::Sysinfo.traffic.to_h   # following metrics as hash

  Vidibus::Sysinfo.traffic.total  # traffic total
  Vidibus::Sysinfo.traffic.input  # input traffic
  Vidibus::Sysinfo.traffic.output # output traffic
```

### Currently used throughput

To get the currently used throughput in MBit/s, call

```ruby
  Vidibus::Sysinfo.throughput.to_f   # throughput total
  Vidibus::Sysinfo.throughput.to_i   # rounded throughput total
  Vidibus::Sysinfo.throughput.to_h   # following metrics as hash

  Vidibus::Sysinfo.throughput.total  # throughput total
  Vidibus::Sysinfo.throughput.input  # input throughput
  Vidibus::Sysinfo.throughput.output # output throughput
```

Throughput detection is performed by analyzing the output of /proc/net/dev.
To get the amount of traffic in a certain timespan, the analyzer gets
called twice and the delta of the two results is the traffic.

By default, throughput detection only waits one second, thus the results
will be quite volatile. To get a more accurate result, you can provide
an optional argument:

```ruby
  Vidibus::Sysinfo.throughput(10)
```

### Storage

To get storage information on the main device in gigabytes, call

```ruby
  Vidibus::Sysinfo.storage.to_f   # used storage
  Vidibus::Sysinfo.storage.to_i   # rounded used storage
  Vidibus::Sysinfo.storage.to_h   # following metrics as hash

  Vidibus::Sysinfo.storage.used   # used storage
  Vidibus::Sysinfo.storage.free   # free storage
  Vidibus::Sysinfo.storage.total  # disk size
```

### Memory

To get the currently used memory in megabytes, call

```ruby
  Vidibus::Sysinfo.memory.to_f   # used memory
  Vidibus::Sysinfo.memory.to_i   # rounded used memory
  Vidibus::Sysinfo.memory.to_h   # following metrics as hash

  Vidibus::Sysinfo.memory.used   # used memory
  Vidibus::Sysinfo.memory.free   # free memory
  Vidibus::Sysinfo.memory.total  # memory size
```

This will ignore memory used for system caching.


### Swap

To get the currently used swap in megabytes, call

```ruby
  Vidibus::Sysinfo.swap.to_f   # used swap
  Vidibus::Sysinfo.swap.to_i   # rounded used swap
  Vidibus::Sysinfo.swap.to_h   # following metrics as hash

  Vidibus::Sysinfo.swap.used   # used swap
  Vidibus::Sysinfo.swap.free   # free swap
  Vidibus::Sysinfo.swap.total  # swap size
```

## Copyright

Copyright (c) 2011-2014 Andre Pankratz. See LICENSE for details.
