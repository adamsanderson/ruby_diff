Gem::Specification.new do |s|
  s.name = %q{ruby_diff}
  s.version = "0.0.1"
  s.date = %q{2008-06-03}
  s.summary = %q{a higher level diff application for analyzing changes to ruby code}
  s.email = ["netghost@gmail.com"]
  s.homepage = %q{RubyDiff does higher level comparisons of ruby code.}
  s.rubyforge_project = %q{rubydiff}
  s.description = %q{}
  s.default_executable = %q{ruby_diff}
  s.has_rdoc = true
  s.authors = ["Adam Sanderson"]
  s.files = [".gitignore", "README.txt", "Rakefile", "bin/ruby_diff", "lib/ruby_diff.rb", "lib/ruby_diff/code_comparison.rb", "lib/ruby_diff/file_feeder.rb", "lib/ruby_diff/git_feeder.rb", "lib/ruby_diff/patterns.rb", "lib/ruby_diff/structure_processor.rb", "ruby_diff.gemspec", "test/file_feeder_test.rb", "test/git_feeder_test.rb", "test/git_sample/README", "test/git_sample/book.rb", "test/git_sample/lib/chapter.rb", "test/structure_processor_test.rb"]
  s.test_files = ["test/git_feeder_test.rb", "test/file_feeder_test.rb", "test/structure_processor_test.rb"]
  s.rdoc_options = ["--main", "README.txt"]
  s.extra_rdoc_files = ["README.txt"]
  s.executables = ["ruby_diff"]
  s.add_dependency(%q<ParseTree>, [">= 2.0.2"])
  s.add_dependency(%q<hoe>, [">= 1.5.3"])
end
