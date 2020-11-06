# lib/creation.rb
require 'ignore_it/list'
require 'readline'
require 'colorize'

module IgnoreIt
  class Creator
    def initialize
      list = List.new
      @jsonResponse = list.jsonResponse
    end

    # Code here
    def create_ignore(name)
      template = @jsonResponse[name]
      contents = template["contents"]

      puts "Creating .gitignore for " + name.colorize(:green)

      if File.exist?(".gitignore")
        # Store the state of the terminal
        sttySave = %x(stty -g).chomp
        overwrite = false

        begin
          puts "File already exists! Overwrite? [y/n]?"
          while (line = Readline.readline('> ', true).downcase)
            # if (line.empty? or line != "y" or line != "n")

            if line == "y"
              overwrite = true
              break
            # puts "yo"
            elsif line == "n"
              break
            # puts "ney"
            elsif (line != "y") || (line != "n")
              puts "Please provide a correct format (y or n)".colorize(:red)
              # puts "wut"
            end
          end
        rescue Interrupt => e
          system('stty', sttySave) # Restore
          exit
        end

        if overwrite
          File.write("./.gitignore", contents)
          puts ".gitignore has been created!".colorize(:green)
        else
          puts ".gitignore has NOT been created! Terminating process!".colorize(:red)
        end

      else
        File.write("./.gitignore", contents)
        puts ".gitignore has been created!".colorize(:green)
      end
    end
  end
end
