#!/usr/bin/env ruby

require_relative 'test_helper'
require 'ignore_it/creator'

module IgnoreIt
  describe List do
    before do
      @list = List.new
    end

    describe "when running -f with a language that does not exist" do
      it "returns false" do
        assert @list.check_list("asdf") == false
      end
    end
    describe "when running -f with a language that does exist" do
      it "returns true" do
        assert @list.check_list("vscode") == true
      end
    end
  end
end
