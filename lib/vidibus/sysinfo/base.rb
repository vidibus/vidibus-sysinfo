module Vidibus
  module Sysinfo

    class CallError < StandardError; end
    class OutputError < StandardError; end
    class ParseError < StandardError; end

    # Provides common methods.
    module Base
      include Helper

      def call
        output, error = perform(command)
        respond(output, error)
      end

      def explain(error); end

      private

      def perform(cmd)
        response = nil
        Open3.popen3(cmd) do |stdin, stdout, stderr|
          response = [stdout.read, stderr.read]
        end
        response
      end

      def respond(output, error)
        if error and error != ""
          reason = explain(error) || open3_reason(error) || error
          raise CallError.new("Failed to call #{self}:\n- #{reason}")
        end

        unless output
          raise OutputError.new("Result from call of #{self} is empty")
        end

        parse(output) or
          raise ParseError.new("Result from call of #{self} could not be parsed: '#{output}'")
      end

      def open3_reason(error)
        if error.match("in `popen3'")
          "the command '#{command}' is not available or this program is not allowed to call it"
        end
      end

      # Converts given amount from unit to megabytes.
      # Treats GB and GiB identically because in our context GB == GiB.
      def megabytes(value, unit = "B")
        value = value.to_f
        case unit
          when 'B'              then value /= 1048576 # bytes
          when 'K', 'KB', 'KiB' then value /= 1024    # kiloytes
          when 'G', 'GB', 'GiB' then value *= 1024    # gigabytes
          when 'T', 'TB', 'TiB' then value *= 1048576 # terabytes
        end
        round(value)
      end

      # Converts given amount from unit to gigabytes.
      def gigabytes(value, unit = "B")
        round(megabytes(value, unit) / 1024)
      end
    end
  end
end
