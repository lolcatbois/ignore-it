# lib/list.rb
# frozen_string_literal: true

require 'net/http'
require 'json'

module IgnoreIt
  class List
    def initialize
      @url = "https://www.toptal.com/developers/gitignore/api/list?format=json"
      @response = Net::HTTP.get(URI(@url))
      @jsonResponse = JSON.parse(@response)
      load_own_files
    end

    attr_reader :jsonResponse, :ownFiles

    # Load own gitignore templates from the directory specified in the config file
    def load_own_files
      @ownFiles = if $glob_settings["own_gitignore_path"] == "default"
        Dir.chdir(Dir.home) do
          Dir.entries(".ignore-it/gitignores/").select do |f|
            f unless f =~ /^..?$/ # some regex magic to remove "." and ".."
          end
        end
      else
        Dir.chdir($glob_settings["own_gitignore_path"]) do
          Dir.entries(".").select do |f|
            f unless f =~ /^..?$/
          end
        end
      end
    end

    # Check if the requested template exists
    def check_own_files(file)
      if @ownFiles.include?(file)
        exists = true
      end
      exists
    end

    # Print all own gitignore templates
    def show_own_files
      @ownFiles.each do |file|
        puts file
      end
    end

    # Check the API List
    def check_list(file)
      exists = false

      @jsonResponse.each do |extension|
        if file == extension.first
          exists = true
          break
        end
      end

      exists
    end

    # Print all gitignore templates fetched by the API
    def show_list
      sortedArray = @jsonResponse.sort

      sortedArray.each do |entry|
        puts entry.first
      end
    end
  end
end
