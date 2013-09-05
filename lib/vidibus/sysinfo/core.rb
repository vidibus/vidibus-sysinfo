module Vidibus
  module Sysinfo

    # Returns number of cpu cores on this system.
    #
    # Analyzes lscpu
    #
    module Core
      extend Base

      class << self
        def command
          'lscpu'
        end

        def parse(output)
          cores = output[/Core\(s\) per socket:\s+(\d+)/i, 1]
          sockets = output[/Socket\(s\):\s+(\d+)/i, 1]
          if cores && sockets
            cores.to_i * sockets.to_i
          end
        end

        def explain(error)
          if error.match('lscpu: command not found')
            return 'lscup is not installed. On Debian you can install it with "apt-get install lscup"'
          end
        end
      end
    end
  end
end
