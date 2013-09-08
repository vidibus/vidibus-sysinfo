module Vidibus
  module Sysinfo

    # Returns currently used throughput in MBit/s.
    #
    # Analyzes /proc/net/dev
    #
    module Throughput
      extend Base

      class << self
        def command
          "cat /proc/net/dev | grep eth0:"
        end

        # Provide seconds to sleep between first and second call.
        # The higher the seconds, the more accurate are the results.
        def call(seconds = 1)
          seconds = seconds.to_i
          values = []
          2.times do
            output, error = perform(command)
            values << respond(output, error)
            sleep(seconds) unless values.size > 1
          end
          megs = values[1] - values[0]
          mbits = (megs*8)/seconds
          round(mbits)
        end

        # Returns sum of transmitted and received bytes in megabytes.
        def parse(output)
          if output.match(/eth0\:([\d\s]+)/)
            numbers = $1.split(/\s+/)
            received = numbers[0].to_i
            transmitted = numbers[8].to_i
            megabytes(received + transmitted)
          end
        end

        def explain(error)
          if error.match("No such file or directory")
            return "This system does not provide /proc/net/dev"
          end
        end
      end
    end
  end
end
