# lib/creation.rb
require 'ignore_it/list'
require 'readline'

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

      if File.exist?(".gitignore")
        # Store the state of the terminal
        sttySave = %x(stty -g).chomp
        overwrite = false

        begin
          puts "File already exists!\nDo you want to continue? y/n?"
          while (line = Readline.readline('> ', true))
            # if (line.empty? or line != "y" or line != "n")

            if line == "y"
              overwrite = true
              break
            # puts "yo"
            elsif line == "n"
              break
            # puts "ney"
            elsif (line != "y") || (line != "n")
              puts "Please provide a correct format (y or n)"
              # puts "wut"
            end
          end
        rescue Interrupt => e
          system('stty', sttySave) # Restore
          exit
        end

        if overwrite
          File.write("./.gitignore", contents)
        else
          puts "Couldn't overrite existing File. Terminating process!"
        end

      else
        File.write("./.gitignore", contents)
      end
    end
  end
end
