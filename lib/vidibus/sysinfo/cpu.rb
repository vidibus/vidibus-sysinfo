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
        KEYS = {
          usr:    :user,
          user:   :user,
          nice:   :nice,
          sys:    :system,
          system: :system,
          iowait: :iowait,
          irq:    :irq,
          soft:   :soft,
          steal:  :steal,
          guest:  :guest,
          idle:   :idle
        }
        attrs *KEYS.values.uniq + [:used]

        def to_i
          round(used, 0).to_i
        end

        def to_f
          used
        end
      end

      class << self
        def command
          'mpstat 1 5'
        end

        # user system missing
        def parse(output)
          lines = output.split(/\r?\n/)
          values = lines[-1].scan(/([\d\.]+)/)
          if values.any?
            values.flatten!
            data = {}
            labels = lines[2].scan(/%([^\s]+)/).flatten
            labels.each_with_index do |label, index|
              key = Result::KEYS[label.to_sym]
              next unless key
              data[key] = values[index].to_f
            end
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
