require 'optparse'
require 'net/http'
require 'json'
require 'readline'

def create_ignore(name)
  response = Net::HTTP.get(URI(@url))
  jsonResponse = JSON.parse(response)
  template = jsonResponse[name]
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

def show_list
  response = Net::HTTP.get(URI(@url))
  jsonResponse = JSON.parse(response)

  num = 0
  jsonResponse.each do |entry|
    if num < 10
      print(entry.first + ", ")
      num += 1
    else
      puts entry.first + ", "
      num = 0
    end
  end
end

@url = "https://www.toptal.com/developers/gitignore/api/list?format=json"
@options = {}
OptionParser.new do |parser|
  parser.on(
    "-f ", "--file FILE", "Select gitignore template to fetch"
  ) do |file|
    create_ignore(file)
    # @options[:file] = true
  end
  parser.on("-c", "--color", "Enable syntax highlighting") do
    @options[:syntax_highlighting] = true
  end
  parser.on("-l", "--list", "Show List of available .gitignore entries") do
    show_list
  end
end.parse!
# p @options
