require 'optparse'
require 'net/http'
require 'json'
require 'readline'


    def CreateIgnore(name)
        response = Net::HTTP.get(URI(@url))
        jsonResponse = JSON.parse(response)
        template = jsonResponse[name]
        contents = template["contents"]
        p contents
        
        if (File.exists?(".gitignore"))
            # Store the state of the terminal
            stty_save = `stty -g`.chomp

            overwrite = false
                
            begin
                puts "File already exists!\nDo you want to continue? y/n?"
                while line = Readline.readline('> ', true) do
                    # if (line.empty? or line != "y" or line != "n")
                        
                    if line == "y"
                        overwrite = true
                        break
                        #puts "yo"
                    elsif line == "n"
                        break
                        #puts "ney"
                    elsif line != "y" or line != "n"
                        puts "Please provide a correct format (y or n)"
                        #puts "wut"
                    end
                end
            rescue Interrupt => e
            system('stty', stty_save) # Restore
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

    def ShowList()
        response = Net::HTTP.get(URI(@url))
        jsonResponse = JSON.parse(response)

        num = 0
        jsonResponse.each do |entry|
            if num < 10
            print entry.first + ", "
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
        "-f ", "--file FILE", "Select gitignore template to fetch") do |file|
        CreateIgnore(file)
        # @options[:file] = true
        end
    parser.on("-c","--color","Enable syntax highlighting") do
        @options[:syntax_highlighting] = true
        end
    parser.on("-l","--list","Show List of available .gitignore entries") do
        ShowList()
        end
    end.parse!
    #p @options


=begin

// RUBY GUIDE FOR COMMAND LINE IMPLEMENTATION
https://www.rubyguides.com/2018/12/ruby-argv/ 

ruby ignore-it.rb -v -c

// working with Files
https://www.rubyguides.com/2015/05/working-with-files-ruby/


// READLINE 
http://bogojoker.com/readline/


// OPTPARSER DOCUMENTATION
https://ruby-doc.org/stdlib-2.7.2/libdoc/optparse/rdoc/OptionParser.html

// API DOCUMENTATION
https://www.toptal.com/developers/gitignore/api/list?format=:format:



//RETURNS: ->
{
	"jboss4": {
		"key": "jboss4",
		"name": "JBoss4",
		"contents": "\n### JBoss4 ###\n# gitignore for JBoss v4 projects\n\n\/server\/all\/data\n\/server\/all\/log\n\/server\/all\/tmp\n\/server\/all\/work\n\/server\/default\/data\n\/server\/default\/log\n\/server\/default\/tmp\n\/server\/default\/work\n\/server\/minimal\/data\n\/server\/minimal\/log\n\/server\/minimal\/tmp\n\/server\/minimal\/work\n\n# Note:\n# there may be other directories that contain *.xml.failed or *.war.failed files\n\/server\/default\/deploy\/*.xml.failed\n\/server\/default\/deploy\/*.war.failed\n",
		"fileName": "JBoss4.gitignore"
	},
	"extjs": {
		"key": "extjs",
		"name": "ExtJs",
		"contents": "\n### ExtJs ###\n.architect\nbootstrap.css\nbootstrap.js\nbootstrap.json\nbootstrap.jsonp\nbuild\/\nclassic.json\nclassic.jsonp\next\/\nmodern.json\nmodern.jsonp\nresources\/sass\/.sass-cache\/\nresources\/.arch-internal-preview.css\n.arch-internal-preview.css\n",
		"fileName": "ExtJs.gitignore"
	}
	...
}
=end