# frozen_string_literal: true
# lib/creation.rb
require 'ignore_it/list'
require 'readline'
require 'colorize'

module IgnoreIt
  class Creator
    def initialize
      @list = List.new
      @jsonResponse = @list.jsonResponse
    end

    def create_file(contents, name)
      puts "Creating .gitignore for " + name.colorize(:green)
      unless $options[:force]
        if File.exist?(".gitignore")
          # Store the state of the terminal
          sttySave = %x(stty -g).chomp
          overwrite = false
          append = false

          begin
            puts "File already exists! Overwrite or append? [y => yes | a => append | n => no]?"
            while (line = Readline.readline('> ', true).downcase)
              if line == "y"
                overwrite = true
                break
              elsif line == "n"
                break
              elsif line == "a"
                append = true
                break
              elsif (line != "y") || (line != "n") || (line != "a")
                puts "Please provide a correct format (y or n)".colorize(:red)
              end
            end
          rescue Interrupt
            system('stty', sttySave) # Restore
            exit
          end

          if overwrite
            File.write("./.gitignore", contents)
            puts ".gitignore has been created!".colorize(:green)
          elsif append
            gitignoreContents = File.read("./.gitignore")
            puts "Adding .gitignore content from " + name.colorize(:green) + " to existing .gitignore File"
            gitignoreContents += contents
            File.write("./.gitignore", gitignoreContents)
          else
            puts ".gitignore has NOT been created! Terminating process!".colorize(:red)
          end
        else
          File.write("./.gitignore", contents)
          puts ".gitignore has been created!".colorize(:green)
        end
      else
        File.write("./.gitignore", contents)
        puts ".gitignore has been created!".colorize(:green)
      end
    end

    def create_own_ignore(name)
      contents = ""
      Dir.chdir(Dir.home) do
        contents = File.read(".ignore-it/gitignores/" + name)
      end
      create_file(contents, name)
    end

    def create_api_ignore(name)
      template = @jsonResponse[name]
      contents = template["contents"]
      create_file(contents, name)
    end
  end
end
