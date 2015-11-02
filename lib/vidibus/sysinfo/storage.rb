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
        def command(mount_point)
          if !mount_point || mount_point == ''
            mp = '/'
          else
            mp = mount_point.gsub(/[^\/a-z0-9]/, '')
          end
          "df -m | grep '#{mp}'"
        end

        def call(mount_point)
          cmd = command(mount_point)
          output, error = perform(cmd)
          respond(output, error)
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
