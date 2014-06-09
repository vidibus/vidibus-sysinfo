module Vidibus
  module Sysinfo

    # Returns system load, divided by number of CPU cores.
    #
    # Calls `uptime`
    #
    module Load
      extend Base

      class Result < Vidibus::Sysinfo::Result
        attrs :one, :five, :fifteen

        def to_f
          one
        end
      end

      class << self
        def command
          "uptime"
        end

        def parse(output)
          number = /\s+(\d+(?:\.\d+)?)/
          if output.match(/load average:#{number},#{number},#{number}/)
            one = $1.to_f
            five = $2.to_f
            fifteen = $3.to_f
            cpus = System.call[:cpus]
            Result.new({
              one: round(one/cpus),
              five: round(five/cpus),
              fifteen: round(fifteen/cpus)
            })
          end
        end
      end
    end
  end
end
