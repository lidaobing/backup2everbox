require 'backup/connection/everbox'

module Backup
  module Storage
    class Everbox < Base

      attr_accessor :token, :secret
      attr_accessor :path

      def initialize(model, storage_id = nil, &block)
        super(model, storage_id)

        @path ||= 'backups'

        instance_eval(&block) if block_given?
      end

      def remove!(pkg)
        remote_path = remote_path_for(pkg)
        Logger.message "#{storage_name} started removing " +
              "'#{ remote_path }'."
        connection.session.delete(remote_path)
      end

      def transfer!
        remote_path = remote_path_for(@package)

        files_to_transfer_for(@package) do |local_file, remote_file|
          Logger.message "#{storage_name} started transferring " +
              "'#{ local_file }'."
          connection.session.upload(
            File.join(local_path, local_file),
            File.join(remote_path, remote_file),
            :mode => :dropbox
            )


          #File.open(File.join(local_path, local_file), 'r') do |file|
          #  connection.put_object(
          #    bucket, File.join(remote_path, remote_file), file
          #  )
          #end
        end
      end

      private
      def connection
        @connection ||= Backup::Connection::Everbox.new(token, secret)
      end
    end
  end
end
