Gem::Specification.new do |s|
  s.name = 'ignore-it'
  s.version = "0.0.1"
  s.date = '2020-11-05'
  s.summary = 'ignore-it your free tool for fetching .gitignore files'
  s.authors = ["Felix Macho", "Simon Sölder"]
  s.files         = Dir.glob("{bin,lib}/**/*")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^test/})
  s.require_paths = ["lib"]
end
