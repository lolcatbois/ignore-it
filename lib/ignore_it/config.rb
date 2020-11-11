require 'yaml'

module IgnoreIt
  class Config
    attr_accessor :config

    def initialize
      $glob_settings = {}
      create_initial_config
      load_config
    end

    def print_config
      puts $glob_settings.to_yaml
    end

    # Load user config from config directory
    def load_config
      Dir.chdir(Dir.home) do
        if File.exist?(".ignore-it/config.yml")
          $glob_settings = YAML.load_file(".ignore-it/config.yml")
        else
          puts "Failed to load user config in ~/.ignore-it/config.yml".colorize(:red)
          puts "Defaulting...".colorize(:red)
          $glob_settings = YAML.load_file(find_gem_root + "/default_config.yml")
        end
      end
    end

    # Find the gems install directory
    def find_gem_root
      spec = Gem::Specification.find_by_name("ignore-it")
      spec.gem_dir
    end

    # Create initial user config and folders in home directory
    def create_initial_config
      Dir.chdir(Dir.home) do
        unless Dir.exist?(".ignore-it")
          Dir.mkdir(".ignore-it")
          Dir.mkdir(".ignore-it/gitignores")
          defaultConfig = File.read(find_gem_root + "/default_config.yml")
          File.write(".ignore-it/config.yml", defaultConfig)
        end
      end
    end
  end
end
