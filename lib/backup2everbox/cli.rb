require 'oauth'
require 'launchy'

module Backup2everbox
  class CLI
    DEFAULT_OPTIONS = {
      :consumer_key => 'GW4YtvBpPwHfY0rCSf2xeOqn7tT0YH2O4zftXCOM',
      :consumer_secret => 'xlKLpZLVSe0Gk6q4w05PsDpzjEbV8SyE71exgz1i',
      :oauth_site => 'http://account.everbox.com',
      :fs_site => 'http://fs.everbox.com',
      :proxy => nil
    }

    def self.execute(stdout, stdin, stderr, arguments = [])
      self.new.execute(stdout, stdin, stderr, arguments)
    end

    def initialize(opts={})
      opts ||= {}
      @options = DEFAULT_OPTIONS.merge(opts)
    end

    def execute(stdout, stdin, stderr, arguments = [])
      request_token = consumer.get_request_token
      url = request_token.authorize_url
      puts "open url in your browser: #{url}"
      Launchy.open(url)
      STDOUT.write "please input the verification code: "
      STDOUT.flush
      verification_code = STDIN.readline.strip
      access_token = request_token.get_access_token :oauth_verifier => verification_code
      puts
      puts "add following code to your ~/Backup/models/foo.rb"
      puts "#" * 50
      puts "  store_with Everbox do |eb|"
      puts "    eb.keep      = 7"
      puts "    eb.token     = '#{access_token.token}'"
      puts "    eb.secret    = '#{access_token.secret}'"
      puts "  end"
      puts "#" * 50
    end

    private
    def consumer
      OAuth::Consumer.new @options[:consumer_key], @options[:consumer_secret], {
        :site => @options[:oauth_site],
        :proxy => @options[:proxy]
      }
    end
  end
end
