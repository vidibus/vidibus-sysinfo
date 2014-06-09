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

      class Result < Vidibus::Sysinfo::Result
        attrs :user, :nice, :system, :iowait, :irq, :soft, :steal, :guest, :idle, :used

        def to_i
          round(used, 0).to_i
        end

        def to_f
          used
        end
      end

      class << self
        def command
          "mpstat 1 5 | grep Average:"
        end

        def parse(output)
          matches = output.scan(/([\d\.]+)/)
          if matches.any?
            matches.flatten!
            data = {
              user: matches[0].to_f,
              nice: matches[1].to_f,
              system: matches[2].to_f,
              iowait: matches[3].to_f,
              irq: matches[4].to_f,
              soft: matches[5].to_f,
              steal: matches[6].to_f,
              guest: matches[7].to_f,
              idle: matches[8].to_f
            }
            data[:used] = round(100.0 - data[:idle])
            Result.new(data)
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
