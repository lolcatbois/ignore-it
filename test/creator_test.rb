#!/usr/bin/env ruby
require_relative 'test_helper'
require 'ignore_it/creator'

module IgnoreIt
  describe Creator do
    before do
      @creator = Creator.new
    end

    describe "when running with -f vscode" do
      it "creates a vscode .gitignore file in the local folder" do
        @creator.create_ignore("vscode")
        assert File.exist?(".gitignore")
      end
      it "contains the vscode gitignore content" do
        response = JSON.parse(Net::HTTP.get(URI("https://www.toptal.com/developers/gitignore/api/list?format=json")))
        contents = response["vscode"]["contents"]
        fileData = File.read(".gitignore")
        assert contents == fileData
      end
    end
  end
end
