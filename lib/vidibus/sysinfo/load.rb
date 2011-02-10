module Vidibus
  module Sysinfo

    # Returns system load, divided by number of CPU cores.
    #
    # Calls `uptime`
    #
    module Load
      extend Base

      class << self
        def command
          "uptime"
        end

        def parse(output)
          if output.match(/load average:\s+(\d+(?:\.\d+)?)/)
            value = $1.to_f
            cores = Core.call
            round(value/cores)
          end
        end
      end
    end
  end
end
