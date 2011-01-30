require 'active_support/core_ext/module/aliasing'

module Backup
  module Connection
    autoload :Everbox, 'backup/connection/everbox'
  end
  module Storage
    autoload :Everbox, 'backup/storage/everbox'
  end
  module Record
    autoload :Everbox, 'backup/record/everbox'
  end
  module Configuration
    class Base
      def storage_class_with_everbox
        res = storage_class_without_everbox
        if res.nil? and @storage_name == :everbox
          res = Backup::Storage::Everbox
        end
        res
      end
      def record_class_with_everbox
        res = record_class_without_everbox
        if res.nil? and @storage_name == :everbox
          res = Backup::Record::Everbox
        end
        res
      end
      alias_method_chain :storage_class, :everbox
    end
  end
end
