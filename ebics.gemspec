Gem::Specification.new do |s|
  s.name        = 'ebics'
  s.version     = '0.0.3'
  s.licenses    = ['MIT']
  s.summary     = "EBICS Ruby Client"
  s.description = "EBICS 2.5 H004 Implementation in Ruby."
  s.authors     = ["Manuel Korfmann"]
  s.email       = 'mkorfmann@sofortwohnen.com'
  s.files       = Dir.glob("{templates,lib}/**/*") + %w(README.md)
  s.require_path = 'lib'
  s.homepage    = 'https://github.com/mkorfmann/ebics'
end
