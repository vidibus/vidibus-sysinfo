module Vidibus
  module Sysinfo

    # Returns consumed storage in gigabytes.
    #
    # Calls `df`
    #
    module Storage
      extend Base

      class Result < Vidibus::Sysinfo::Result
        attrs :total, :used, :free

        def to_i
          round(used, 0).to_i
        end

        def to_f
          used.to_f
        end
      end

      class << self
        def command
          'df -m'
        end

        def parse(output)
          device = /(?:[\/a-z0-9]+)/
          size = /\s+(\d+)\i?/
          if matches = output.match(/#{device}#{size}#{size}#{size}/m)
            total = $1.to_f
            used = $2.to_f
            free = $3.to_f
            Result.new({
              total: gigabytes(total, 'M'),
              used: gigabytes(used, 'M'),
              free: gigabytes(free, 'M')
            })
          end
        end
      end
    end
  end
end
