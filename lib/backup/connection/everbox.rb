require 'cgi'

require 'oauth'
require 'json'
require 'rest_client'
require 'pp'


module Backup
  module Connection
    class Everbox

      class Session
        DEFAULT_OPTIONS = {
          :oauth_site => 'http://account.everbox.com',
          :fs_site => 'http://fs.everbox.com',
          :chunk_size => 1024*1024*4
        }
        attr_accessor :authorizing_user, :authorizing_password, :access_token
        def initialize(apikey, secret, opts={})
          @consumer = OAuth::Consumer.new apikey, secret, :site => 'http://account.everbox.com'
          @options = DEFAULT_OPTIONS.merge(opts || {})
        end

        def authorize!
          response = @consumer.request(:post, "/oauth/quick_token?login=#{CGI.escape @authorizing_user}&password=#{CGI.escape @authorizing_password}")
          if response.code.to_i != 200
            raise "login failed: #{response.body}"
          end

          d = CGI.parse(response.body).inject({}) do |h,(k,v)|
            h[k.strip.to_sym] = v.first
            h[k.strip]        = v.first
            h
          end

          @access_token = OAuth::AccessToken.from_hash(@consumer, d)
        end

        def authorized?
          !!@access_token
        end

        def upload(filename, remote_path, opts={})
          mkdir_p(remote_path)
          basename = File.basename(filename)
          target_path = File.expand_path(basename, remote_path)
          keys = calc_digests(filename)
          params = {
            :path      => target_path,
            :keys      => keys,
            :chunkSize => 4*1024*1024,
            :fileSize  => File.open(filename).stat.size,
            :base      => ''
          }
          pp params
          info = JSON.parse(access_token.post(fs(:prepare_put), JSON.dump(params), {'Content-Type' => 'text/plain' }).body)
          pp info
          File.open(filename) do |f|
            info["required"].each do |x|
              puts "upload block ##{x["index"]}"
              f.seek(x["index"] * @options[:chunk_size])
              code, response = http_request x['url'], f.read(@options[:chunk_size]), :method => :put
              if code != 200
                raise code.to_s
              end
            end
          end


          ftime = (Time.now.to_i * 1000 * 1000 * 10).to_s
          params = params.merge :editTime => ftime, :mimeType => 'application/octet-stream'
          pp access_token
          code, response = access_token.post(fs(:commit_put), params.to_json, {'Content-Type' => 'text/plain'})
          pp code, response
        end

        def delete(remote_path, opts={})
        end

        private
        def edit_time(time = nil)
          time ||= Time.now
          (time.to_i * 1000 * 1000 * 10).to_s
        end
        
        def mkdir_p(path)
          return if path == "/"
          mkdir_p(File.expand_path("..", path))
          make_remote_path(path, :ignore_conflict => true)
        end

        def make_remote_path(path, opts = {})
          data = {
            :path => path,
            :editTime => edit_time
          }
          response = access_token.post(fs(:mkdir), data.to_json, {'Content-Type' => 'text/plain'})
          case response.code
          when "200"
            #
          when "409"
            unless opts[:ignore_conflict]
              raise "directory already exist: `#{path}'"
            end
          end
        end
        def http_request url, data = nil, options = {}
          begin
            options[:method] = :post unless options[:method]
            case options[:method]
            when :get
              response = RestClient.get url, data, :content_type => options[:content_type]
            when :post
              response = RestClient.post url, data, :content_type => options[:content_type]
            when :put
              response = RestClient.put url, data
            end
            body = response.body
            data = nil
            data = JSON.parse body unless body.empty?
            [response.code.to_i, data]
          rescue => e
            raise
            code = 0
            data = nil
            body = nil
            res = e.response if e.respond_to? :response
            begin
              code = res.code if res.respond_to? :code
              body = res.body if res.respond_to? :body
              data = JSON.parse body unless body.empty?
            rescue
              data = body
            end
            [code, data]
          end
        end
        def fs(path)
          path = path.to_s
          path = '/' + path unless path.start_with? '/'
          @options[:fs_site] + path
        end
        def urlsafe_base64(content)
          Base64.encode64(content).strip.gsub('+', '-').gsub('/','_')
        end

        def calc_digests(fname)
          res = []
          File.open(fname) do |ifile|
            while (data = ifile.read(@options[:chunk_size])) do
              res << urlsafe_base64(Digest::SHA1.digest(data))
            end
          end
          res 
        end
      end

      attr_accessor :adapter, :procedure, :final_file, :tmp_path, :api_key, :secret_access_key, :username, :password, :path

      def initialize(adapter=false)
        if adapter
          self.adapter            = adapter
          self.procedure          = adapter.procedure
          self.final_file         = adapter.final_file
          self.tmp_path           = adapter.tmp_path.gsub('\ ', ' ')

          load_storage_configuration_attributes
        end
      end

      def static_initialize(procedure)
        self.procedure = procedure
        load_storage_configuration_attributes(true)
      end

      def session
        @session ||= Session.new(api_key, secret_access_key)
        unless @session.authorized?
          @session.authorizing_user = username
          @session.authorizing_password = password
          @session.authorize!
        end

        @session
      end

      def connect
        session
      end

      def path
        @path || "backups"
      end

      def store
        path_to_file = File.join(tmp_path, final_file)
        session.upload(path_to_file, path, :mode => :dropbox)
      end

      private

      def load_storage_configuration_attributes(static=false)
        %w(api_key secret_access_key username password path).each do |attribute|
          if static
            send("#{attribute}=", procedure.get_storage_configuration.attributes[attribute])
          else
            send("#{attribute}=", adapter.procedure.get_storage_configuration.attributes[attribute])
          end
        end
      end
    end
  end
end
