Gem::Specification.new do |s|
  s.name = %q{ruby_diff}
  s.version = "0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Adam Sanderson"]
  s.date = %q{2008-10-02}
  s.default_executable = %q{ruby_diff}
  s.description = %q{}
  s.email = ["netghost@gmail.com"]
  s.executables = ["ruby_diff"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = [".gitignore", "History.txt", "Manifest.txt", "README.txt", "Rakefile", "bin/ruby_diff", "lib/ruby_diff.rb", "lib/ruby_diff/code_comparison.rb", "lib/ruby_diff/file_feeder.rb", "lib/ruby_diff/git_feeder.rb", "lib/ruby_diff/git_support.rb", "lib/ruby_diff/git_working_dir_feeder.rb", "lib/ruby_diff/patterns.rb", "lib/ruby_diff/structure_processor.rb", "lib/ruby_diff/svn_feeder.rb", "ruby_diff.gemspec", "test/code_comparison_test.rb", "test/file_feeder_test.rb", "test/git_feeder_test.rb", "test/git_sample/README", "test/git_sample/book.rb", "test/git_sample/lib/chapter.rb", "test/git_working_dir_feeder_test.rb", "test/structure_processor_test.rb"]
  s.has_rdoc = true
  s.homepage = %q{RubyDiff does higher level comparisons of ruby code.}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rubydiff}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{a higher level diff application for analyzing changes to ruby code}
  s.test_files = ["test/git_feeder_test.rb", "test/file_feeder_test.rb", "test/code_comparison_test.rb", "test/structure_processor_test.rb", "test/git_working_dir_feeder_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<ParseTree>, ["~> 2.1"])
      s.add_development_dependency(%q<hoe>, [">= 1.7.0"])
    else
      s.add_dependency(%q<ParseTree>, ["~> 2.1"])
      s.add_dependency(%q<hoe>, [">= 1.7.0"])
    end
  else
    s.add_dependency(%q<ParseTree>, ["~> 2.1"])
    s.add_dependency(%q<hoe>, [">= 1.7.0"])
  end
end
