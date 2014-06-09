module Vidibus
  module Sysinfo

    # Returns used swap in megabytes.
    #
    # Calls `free`
    #
    module Swap
      extend Base

      class Result < Vidibus::Sysinfo::Result
        attrs :total, :used, :free

        def to_i
          round(used, 0).to_i
        end

        def to_f
          used.to_f
        end
      end

      class << self
        def command
          "free -m | grep Swap:"
        end

        def parse(output)
          if output.match(/^Swap:\s+([\d\s]+)$/)
            numbers = $1.split(/\s+/)
            Result.new({
              total: numbers[0].to_i,
              used: numbers[1].to_i,
              free: numbers[2].to_i
            })
          end
        end
      end
    end
  end
end
