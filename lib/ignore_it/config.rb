require 'yaml'

module IgnoreIt
  class Config
    attr_accessor :config

    def initialize
      $glob_settings = {
        "api" => "gitignore.io",
        "fetch" => "direct",
        "own_gitignore_files" => "default", # absolute path to own gitignore files
      }
      create_initial_config
      load_config
    end

    def print_config
      puts @config.to_yaml
    end

    def load_config
      Dir.chdir(Dir.home) do
        @glob_settings = YAML.load_file(".ignore-it/config.yml")
      end
    end

    def create_initial_config
      Dir.chdir(Dir.home) do
        unless Dir.exist?(".ignore-it")
          Dir.mkdir(".ignore-it")
          Dir.mkdir(".ignore-it/gitignores")
          # File.open(".ignore-it/config.yml", "w") do |file|
          #   YAML.dump($config)
          # end
          File.write(".ignore-it/config.yml", YAML.dump($glob_settings))
        end
      end
    end
  end
end
