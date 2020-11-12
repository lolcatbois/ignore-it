# frozen_string_literal: true
require 'net/http'
require 'json'
require 'colorize'
require 'readline'
require 'ignore_it/list'
require 'ignore_it/config'
require 'ignore_it/creator'
require 'thor'

module IgnoreIt
  class CLI < Thor
    def initialize(*args)
      super
      @config = Config.new
      @creator = Creator.new
      @list = List.new
      $glob_settings[:output] = "./.gitignore"
    end

    class_options force: :boolean, output: :string

    desc "add [templateName]", "Select gitignore template to create a .gitignore file
    or add a template to an existing .gitignore file"
    def add(*templateName)
      if options[:output]
        unless @creator.check_output_path(options[:output])
          return false
        end
        $glob_settings[:output] = if options[:output][-1] == '/'
          options[:output] + '.gitignore'
        else
          options[:output] + '/.gitignore'
        end
      end
      if options[:force]
        $glob_settings[:force] = true
      end
      templateName.each do |name|
        puts name
      end
      templateName.each do |name|
        name = name.downcase
        if @list.check_list(name)
          @creator.create_api_ignore(name)
        else
          puts "The template #{name} you tried to fetch does not exist".colorize(:red)
          puts "Please checkout the available templates with " + "ignore-it list".colorize(:green)
        end
      end
    end

    desc "own [fileName]", "Select user-created template from the folder specified in ~/.ignore-it/config.yml. Default is ~/.ignore-it/gitignores/."
    def own(*fileName)
      if options[:output]
        unless @creator.check_output_path(options[:output])
          return false
        end
        $glob_settings[:output] = if options[:output][-1] == '/'
          options[:output] + '.gitignore'
        else
          options[:output] + '/.gitignore'
        end
      end
      if options[:force] == true
        $glob_settings[:force] = true
      end
      fileName.each do |name|
        if @list.check_own_files(name)
          @creator.create_own_ignore(name)
        else
          puts "The template #{name} you tried to create does not exist".colorize(:red)
          puts "The following templates are available:".colorize(:red)
          @list.show_own_files
        end
      end
    end

    desc "list", "Show List of available .gitignore entries"
    def list
      puts "---- Available templates from gitignore.io: ----"
      @list.show_list
      puts "---- Available user templates (see ~/.ignore-it/config.yml) ----"
      @list.show_own_files
    end
  end
end
