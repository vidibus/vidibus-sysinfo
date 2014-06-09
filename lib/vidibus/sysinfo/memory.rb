module Vidibus
  module Sysinfo

    # Returns used memory in megabytes.
    #
    # Calls `free`
    #
    module Memory
      extend Base

      class Result < Vidibus::Sysinfo::Result
        attrs :total, :used, :free

        def to_i
          used
        end

        def to_f
          used.to_f
        end
      end

      class << self
        def command
          "free -m | grep Mem:"
        end

        def parse(output)
          if output.match(/^Mem:\s+([\d\s]+)$/)
            numbers = $1.split(/\s+/)
            total = numbers[0].to_i
            buffers = numbers[4].to_i
            cached = numbers[5].to_i
            used = numbers[1].to_i - buffers - cached
            Result.new({
              total: total,
              used: used,
              free: total - used
            })
          end
        end
      end
    end
  end
end
