require 'backup/connection/everbox'

module Backup
  module Storage
    class Everbox < Base
      def initialize(adapter)
        everbox = Backup::Connection::Everbox.new(adapter)
        everbox.store
      end
    end
  end
end
