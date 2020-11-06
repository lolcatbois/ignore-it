require 'net/http'
require 'json'
require 'readline'
require 'ignore_it/list'
require 'ignore_it/creator'

module IgnoreIt
  class Main
    # constructor
    def initialize
      @url = "https://www.toptal.com/developers/gitignore/api/list?format=json"
      @options = {}
      @list = List.new
      @creator = Creator.new
    end

    def start

      ARGV << '-h' if ARGV.empty?

      OptionParser.new do |parser|
        parser.banner = "How to Use ignore-it: Pass one of the following options: e.g => ignore-it -f csharp"
        parser.on(
          "-f ", "--file FILE", "Select gitignore template to fetch"
        ) do |file|
          if @list.check_list(file)
            @creator.create_ignore(file)
          else
            puts "The template you tried to fetch does not exist\nPlease checkout the available templates with ruby lib/ignore-it.rb -l / --list"
          end
          # @options[:file] = true
        end
        parser.on("-l", "--list", "Show List of available .gitignore entries") do
          @list.show_list
        end
      end.parse!
    end
  end
end
