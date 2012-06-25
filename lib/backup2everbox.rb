require 'backup/config/everbox'

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
end
