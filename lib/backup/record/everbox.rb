require 'backup/connection/everbox'

module Backup
  module Record
    class Everbox < Backup::Record::Base
      def load_specific_settings(adapter)
      end

      private

      def self.destroy_backups(procedure, backups)
        everbox = Backup::Connection::Everbox.new
        everbox.static_initialize(procedure)
        session = everbox.session
        backups.each do |backup|
          puts "\nDestroying backup \"#{backup.filename}\"."
          path_to_file = File.join(everbox.path, backup.filename)
          session.delete(path_to_file, :mode => :everbox)
        end
      end
    end
  end
end
