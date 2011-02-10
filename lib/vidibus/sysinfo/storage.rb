module Vidibus
  module Sysinfo

    # Returns consumed storage in gigabytes.
    #
    # Calls `df`
    #
    module Storage
      extend Base

      class << self
        def command
          "df -h"
        end

        def parse(output)
          device = /(?:[\/a-z0-9]+)/
          size = /\s+([\d\.]+)(K|M|G|T)\i?/
          if output.match(/#{device}#{size}#{size}/m)
            amount = $3.to_f
            unit = $4
            gigabytes(amount, unit)
          end
        end
      end
    end
  end
end
