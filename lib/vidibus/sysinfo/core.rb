module Vidibus
  module Sysinfo

    # Returns number of CPUs on this system.
    #
    # Analyzes lscpu
    #
    module Core
      extend Base

      class << self
        def command()
          'lscpu'
        end

        def parse(output)
          if cpus = output[/CPU\(s\):\s+(\d+)/i, 1]
            cpus.to_i
          end
        end

        def explain(error)
          if error.match('lscpu: command not found')
            return 'lscpu is not installed. On Debian you can install it with "apt-get install lscpu"'
          end
        end
      end
    end
  end
end
