require 'backup/config/everbox'

module Backup
  module Connection
    autoload :Everbox, 'backup/connection/everbox'
  end
  module Storage
    autoload :Everbox, 'backup/storage/everbox'
  end
end
