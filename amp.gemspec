require 'rubygems'

AMP_GEMSPEC = Gem::Specification.new do |spec|
  # spec.rubyforge_project = 'sass'
  spec.name = 'amp'
  spec.summary = "An HTML Parsifier. Adds classes to things."
  spec.version = File.read(File.dirname(__FILE__) + '/VERSION').strip
  spec.authors = ['Elliott Kember']
  spec.email = 'elliott.kember@gmail.com'

  spec.description = <<-END
      An HTML parsifier. Adds classes to elements in an HTML file.
      It replaces hpricot or nokogiri, and attempts to do the impossible: parse HTML using a regular expression.
      Not really, of course - it just adds classes to a few certain elements. But there exists a special circle
      of hell for people who parse HTML with regular expressions, and I thought it a shame to miss out.
      The name Amp, of course, is an electrical pun - the amp, or ampere, being a measure of electrical current.
    END

  spec.required_ruby_version = '>= 1.8.7'

  spec.add_development_dependency 'bundler', '>= 1.3.5'
  spec.add_development_dependency 'shoulda'
  spec.add_development_dependency 'test-unit'
  spec.add_development_dependency 'rake'

  spec.files        = `git ls-files`.split($/)
  spec.test_files   = spec.files.grep(%r{^spec/})
  spec.require_path = 'lib'
  
  spec.test_files = Dir['test/**/*_test.rb']
  spec.license = "MIT"
end