module Vidibus
  module Sysinfo

    # Returns number of CPUs on this system.
    #
    # Analyzes lscpu
    #
    module Core
      extend Base

      class Result < Vidibus::Sysinfo::Result
        attrs :cpus, :cores, :sockets

        def to_i
          cpus
        end

        def to_f
          cpus.to_f
        end
      end

      class << self
        def command()
          'lscpu'
        end

        def parse(output)
          sockets = output[/Socket\(s\):\s+(\d+)/i, 1]
          cores = output[/Core\(s\) per socket:\s+(\d+)/i, 1]
          cpus = output[/CPU\(s\):\s+(\d+)/i, 1]
          if sockets && cores && cpus
            Result.new({
              sockets: sockets.to_i,
              cores: cores.to_i,
              cpus: cpus.to_i
            })
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
