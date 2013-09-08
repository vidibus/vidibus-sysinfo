module Vidibus
  module Sysinfo

    # Returns CPU utilization in percent.
    #
    # Calls `mpstat`
    #
    # mpstat is part of the "systat" tools for Linux.
    # Installation on Debian:
    #   apt-get install sysstat
    #
    module Cpu
      extend Base

      class << self
        def command
          "mpstat 1 5 | grep Average:"
        end

        def parse(output)
          if output.match(/([\d\.]+)$/)
            round(100.0 - $1.to_f)
          end
        end

        def explain(error)
          if error.match("mpstat: command not found")
            return "mpstat is not installed. On Debian, you can install it with 'apt-get install sysstat'"
          end
        end
      end
    end
  end
end
