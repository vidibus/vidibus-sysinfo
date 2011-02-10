module Vidibus
  module Sysinfo

    # Returns used memory in megabytes.
    #
    # Calls `free`
    #
    module Memory
      extend Base

      class << self
        def command
          "free -m | grep Mem:"
        end

        def parse(output)
          if output.match(/^Mem:\s+([\d\s]+)$/)
            numbers = $1.split(/\s+/)
            used = numbers[1].to_i
            cached = numbers[5].to_i
            used - cached
          end
        end
      end
    end
  end
end
