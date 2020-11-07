Gem::Specification.new do |s|
  s.name = 'ignore-it'
  s.version = "1.0.1"
  s.date = '2020-11-07'
  s.summary = 'ignore-it your command line tool for fetching .gitignore files'
  s.authors = ["Felix Macho", "Simon Sölder"]
  s.metadata = { "source_code_uri" => "https://github.com/lolcatbois/ignore-it" }
  s.files = Dir.glob("{bin,lib}/**/*")
  s.licenses = ['MIT']
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^test/})
  s.require_paths = ["lib"]

  # DEPENDENCIES
  s.add_development_dependency("rake", "~> 11.3.0")
  s.add_development_dependency("rubocop", "~> 1.2")
  s.add_runtime_dependency('colorize', "~> 0.8.1")
end
