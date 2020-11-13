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
      unless $glob_settings[:force]
        if File.exist?($glob_settings[:output])
          sttySave = %x(stty -g).chomp # Store the state of the terminal
          overwrite = false
          append = false
          begin
            puts "File" + " .gitignore ".colorize(:yellow) + "already exists!"
            puts "Overwrite or append? [y => yes | a => append | n => no]?"
            while (line = Readline.readline('> ', true).downcase)
              if line == "y"
                overwrite = true
                break
              elsif line == "n"
                break
              elsif line == "a"
                append = true
                break
              else
                puts "Please provide a correct format (y or n)".colorize(:red)
              end
            end
          rescue Interrupt
            system('stty', sttySave) # Restore
            exit
          end

          if overwrite
            if $glob_settings[:recursive]
              recursiveContent = ""
              contents.each_line do |thisLine|
                recursiveContent += unless thisLine[0] == '#' || thisLine == "\n"
                  '**/' + thisLine.to_s
                else
                  thisLine.to_s
                end
              end
              contents = recursiveContent
            end
            File.write($glob_settings[:output], contents)
            puts ".gitignore has been created!".colorize(:green)
          elsif append
            if $glob_settings[:recursive]
              recursiveContent = ""
              contents.each_line do |thisLine|
                recursiveContent += unless thisLine[0] == '#' || thisLine == "\n"
                  '**/' + thisLine.to_s
                else
                  thisLine.to_s
                end
              end
              contents = recursiveContent
            end
            gitignoreContents = File.read($glob_settings[:output])
            puts "Adding .gitignore content from " + name.colorize(:green) + " to existing .gitignore File"
            gitignoreContents += contents
            File.write($glob_settings[:output], gitignoreContents)
          else
            puts ".gitignore has NOT been created! Terminating process!".colorize(:red)
          end
        else
          File.write($glob_settings[:output], contents)
          puts ".gitignore has been created!".colorize(:green)
        end
      else
        File.write($glob_settings[:output], contents)
        puts ".gitignore has been created!".colorize(:green)
      end
    end

    def create_own_ignore(name)
      contents = ""
      if $glob_settings["own_gitignore_path"] == "default"
        Dir.chdir(Dir.home) do
          contents = File.read(".ignore-it/gitignores/" + name)
        end
      else
        Dir.chdir($glob_settings["own_gitignore_path"]) do
          contents = File.read(name)
        end
      end
      create_file(contents, name)
    end

    def create_api_ignore(name)
      template = @jsonResponse[name]
      contents = template["contents"]
      create_file(contents, name)
    end

    def check_output_path(name)
      if Dir.exist?(name)
        true
      else
        puts "The Output Path you provided does currently not exist, please create it manually before using --output".colorize(:red)
      end
    end
  end
end
