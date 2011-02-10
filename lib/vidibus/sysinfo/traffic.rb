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

      class << self
        def command
          "vnstat -m"
        end

        def parse(output)
          month = /(\s*\w{3} \'\d{2})/
          traffic = /\s*(\d+(?:\.\d+)?) (kB|MB|GB|TB)\s*/
          last_month = output.split(/\r?\n/)[-3]
          if last_month and last_month.match(/#{month}#{traffic}\|#{traffic}\|#{traffic}+/m)
            amount = $6.to_f
            unit = $7
            gigabytes(amount, unit)
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
