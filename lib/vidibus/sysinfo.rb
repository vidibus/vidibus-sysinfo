require 'open3'
require 'vidibus/sysinfo/helper'
require 'vidibus/sysinfo/base'
require 'vidibus/sysinfo/result'
require 'vidibus/sysinfo/core'
require 'vidibus/sysinfo/cpu'
require 'vidibus/sysinfo/load'
require 'vidibus/sysinfo/traffic'
require 'vidibus/sysinfo/throughput'
require 'vidibus/sysinfo/storage'
require 'vidibus/sysinfo/memory'
require 'vidibus/sysinfo/swap'

module Vidibus
  module Sysinfo
    class << self

      # Returns number of cpu cores.
      def core
        Core.call
      end

      # Returns CPU utilization in percent.
      def cpu
        Cpu.call
      end

      # Returns system load, divided by number of CPU cores.
      def load
        Load.call
      end

      # Returns total traffic of this month in gigabytes.
      def traffic
        Traffic.call
      end

      # Returns currently used throughput in MBit/s.
      # Provide seconds to improve measurement.
      # The higher the seconds, the more accurate are the results.
      def throughput(seconds = 1)
        Throughput.call(seconds)
      end

      # Returns consumed storage in gigabytes.
      def storage
        Storage.call
      end

      # Returns used memory in megabytes.
      def memory
        Memory.call
      end

      # Returns used swap in megabytes.
      def swap
        Swap.call
      end
    end
  end
end
