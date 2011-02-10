module Vidibus
  module Sysinfo

    # Returns used swap in megabytes.
    #
    # Calls `free`
    #
    module Swap
      extend Base

      class << self
        def command
          "free -m | grep Swap:"
        end

        def parse(output)
          if output.match(/^Swap:\s+([\d\s]+)$/)
            numbers = $1.split(/\s+/)
            numbers[1].to_i
          end
        end
      end
    end
  end
end
