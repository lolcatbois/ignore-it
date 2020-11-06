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
    end

    attr_reader :jsonResponse

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

    def show_list
      sortedArray = @jsonResponse.sort

      sortedArray.each do |entry|
        puts entry.first
      end
    end
  end
end
