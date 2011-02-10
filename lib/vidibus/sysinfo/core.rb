module Vidibus
  module Sysinfo

    # Returns number of cpu cores on this system.
    #
    # Analyzes /proc/cpuinfo
    #
    module Core
      extend Base

      class << self
        def command
          "cat /proc/cpuinfo | grep processor | wc -l"
        end

        def parse(output)
          if output.match(/\d+/)
            output.to_i
          end
        end

        def explain(error)
          if error.match("No such file or directory")
            return "This system does not provide /proc/cpuinfo"
          end
        end
      end
    end
  end
end
