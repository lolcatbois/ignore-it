Gem::Specification.new do |s|
  s.name = 'ignore-it'
  s.version = "1.0.2"
  s.date = '2020-11-07'
  s.summary = 'ignore-it your command line tool for fetching .gitignore files from gitignore.io'
  s.description = <<-EOF
    Feel it's sometimes cumbersome to browse to a website, only to download a .gitignore?
    We've got your back!
    ignore-it is a small cli tool, which helps in fetching and creating .gitignore files.
    We try to keep runtime dependencies as small as possible and are using mostly standard ruby libraries. 
  EOF
  s.authors = ["Felix Macho", "Simon Sölder"]
  s.metadata = { "source_code_uri" => "https://github.com/lolcatbois/ignore-it" }
  s.files = Dir.glob("{bin,lib}/**/*")
  s.licenses = ['MIT']
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^test/})
  s.require_paths = ["lib"]

  # DEV DEPENDENCIES
  s.add_development_dependency("rake", ">= 11.3.0")
  s.add_development_dependency("minitest")

  # RUNTIME DEPENDENCIES
  s.add_runtime_dependency('colorize', ">= 0.8.1")
end
