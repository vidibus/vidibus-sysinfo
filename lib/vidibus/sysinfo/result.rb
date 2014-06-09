module Vidibus
  module Sysinfo
    class Result
      include Helper

      def initialize(options)
        attrs.each do |attr|
          instance_variable_set("@#{attr}", options[attr])
        end
      end

      private

      def attrs
        self.class.instance_variable_get('@attrs')
      end

      class << self
        def attrs(*args)
          self.send(:attr, *args)
          @attrs = args
        end
      end
    end
  end
end
