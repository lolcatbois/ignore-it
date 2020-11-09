# frozen_string_literal: true
require 'net/http'
require 'json'
require 'colorize'
require 'readline'
require 'ignore_it/list'
require 'ignore_it/creator'

module IgnoreIt
  class Main
    # constructor
    def initialize
      @url = "https://www.toptal.com/developers/gitignore/api/list?format=json"
      $options = {}
      @list = List.new
      @creator = Creator.new
      create_config_folder
    end

    def start
      ARGV << '-h' if ARGV.empty?
      if ARGV.include?("--f")
        $options[:force] = true
      end

      OptionParser.new do |parser|
        parser.banner = "How to Use ignore-it: Pass one of the following options: e.g => ignore-it -a csharp"
        parser.on("-a ", "--add FILE", "Select gitignore template to create a .gitignore file or add a template to an existing .gitignore file") do |file|
          if !file.empty?
            file = file.downcase
            if @list.check_list(file)
              @creator.create_ignore(file)
            else
              puts "The template you tried to fetch does not exist".colorize(:red)
              puts "Please checkout the available templates with " + "ignore-it -l".colorize(:green)
            end
          else
            puts "You need to pass arguments (e.g => ignore-it -a **NAME**)"
          end
        end
        parser.on("-o ", "--own FILE", "Select user-created template from ~/.ignore-it/gitignores/") do |file|
          if !file.empty?
            if @list.check_own_files(file)
              @creator.create_own_ignore(file)
            else
              puts "The template you tried to create does not exist in ~/.ignore-it/gitignores/".colorize(:red)
              puts "The following templates are available:".colorize(:red)
              @list.show_own_files
            end
          else
            puts "You need to pass arguments (e.g => ignore-it -o **NAME**)"
          end
        end
        parser.on("-l", "--list", "Show List of available .gitignore entries") do
          puts "---- Available templates from gitignore.io: ----"
          @list.show_list
          puts "---- Available templates from ~/.ignore-it/gitignores/: ----"
          @list.show_own_files
        end
        parser.on("--f", "--force", "Force overwriting the current .gitignore file") do
        end
      end.parse!
      # $options[:force]
    end

    def create_config_folder
      Dir.chdir(Dir.home) do
        unless Dir.exist?(".ignore-it")
          Dir.mkdir(".ignore-it")
          Dir.mkdir(".ignore-it/gitignores")
        end
      end
    end
  end
end
