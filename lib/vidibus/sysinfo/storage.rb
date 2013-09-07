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
          'df -m'
        end

        def parse(output)
          device = /(?:[\/a-z0-9]+)/
          size = /\s+(\d+)\i?/
          if output.match(/#{device}#{size}#{size}/m)
            amount = $2.to_f
            gigabytes(amount, 'M')
          end
        end
      end
    end
  end
end
