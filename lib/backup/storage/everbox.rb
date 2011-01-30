require 'backup/connection/everbox'

module Backup
  module Storage
    class Everbox < Base
      def initialize(adapter)
        dropbox = Backup::Connection::Everbox.new(adapter)
        dropbox.store
      end
    end
  end
end
