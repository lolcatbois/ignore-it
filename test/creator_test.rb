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
        @creator.create_ignore("chsarp")
        assert File.exist?(".gitignore")
      end
    end
  end
end
