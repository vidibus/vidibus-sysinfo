module Vidibus
  module Sysinfo

    # Returns currently used throughput in MBit/s.
    #
    # Analyzes /proc/net/dev
    #
    module Throughput
      extend Base

      class Result < Vidibus::Sysinfo::Result
        attrs :input, :output

        def to_h
          super.merge(total: total)
        end

        def total
          round(input + output)
        end

        def to_i
          round(total, 0).to_i
        end

        def to_f
          total.to_f
        end
      end

      class << self
        def command
          "cat /proc/net/dev | grep #{link_ether}"
        end

        def link_ether
          return @link_ether if @link_ether
          @link_ether, _error = perform("ip -o link | grep -m 1 link/ether | awk {'print $2'}")
          @link_ether.strip
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
          result = {}
          [:input, :output].each do |type|
            megs = values[1][type] - values[0][type]
            result[type] = round((megs*8)/seconds)
          end
          Result.new(result)
        end

        # Returns received and sent megabytes.
        def parse(output)
          if output.strip.match(/#{Regexp.escape(link_ether)}\s*([\d\s]+)/)
            numbers = $1.strip.split(/\s+/)
            input = numbers[0].to_i
            output = numbers[8].to_i
            {
              input: megabytes(input),
              output: megabytes(output)
            }
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
