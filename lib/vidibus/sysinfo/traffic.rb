module Vidibus
  module Sysinfo

    # Returns total traffic of this month in gigabytes.
    #
    # Calls `vnstat`
    #
    # Installation on Debian:
    #   apt-get install vnstat
    #   vnstat -u -i eth0
    #
    module Traffic
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
          "vnstat -m"
        end

        def parse(output)
          month = /(\s*\w{3} \'\d{2})/
          traffic = /\s*(\d+(?:\.\d+)?) (ki?B|Mi?B|Gi?B|Ti?B)\s*/i
          last_month = output.split(/\r?\n/)[-3]
          if last_month && last_month.match(/#{month}#{traffic}\|#{traffic}\|#{traffic}+/m)
            input_amount = $2.to_f
            input_unit = $3
            output_amount = $4.to_f
            output_unit = $5
            Result.new({
              input: gigabytes(input_amount, input_unit),
              output: gigabytes(output_amount, output_unit)
            })
          elsif output.match("Not enough data available yet")
            0.0
          end
        end

        def explain(error)
          if error.match("vnstat: command not found")
            return "vnstat is not installed. On Debian, you can install it with 'apt-get install vnstat' and 'vnstat -u -i eth0'"
          end
        end
      end
    end
  end
end
