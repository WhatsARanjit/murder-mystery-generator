lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name        = 'murder-mystery-generator'
  s.version     = '0.0.0'
  s.date        = '2015-07-26'
  s.summary     = "Generate murder mystery graphs and character profiles."
  s.description = "Used to create base skeleton for a Murder Mystery."
  s.authors     = ["Ranjit Viswakumar"]
  s.email       = 'whatsaranjit@gmail.com'
  s.homepage    = "https://github.com/WhatsARanjit/murder-mystery-generator"
  s.files       = ["lib/hola.rb"]
  s.homepage    =
    'http://rubygems.org/gems/hola'
  s.license       = 'MIT'
  s.files        = %x[git ls-files].split($/)
  s.require_path = 'lib'
  s.bindir       = 'bin'
  s.executables  = 'murder'

  s.test_files   = Dir.glob("spec/**/*_spec.rb")
end
