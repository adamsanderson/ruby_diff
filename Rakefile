require 'rubygems'
require 'hoe'
require './lib/ruby_diff.rb'

task :default => "git:changed"
task :release => "git:push"

HOE = Hoe.new('ruby_diff', RubyDiff::VERSION) do |p|
  p.rubyforge_name = 'rubydiff'
  p.developer('Adam Sanderson', 'netghost@gmail.com')
  p.remote_rdoc_dir = '' # Release to root
  p.test_globs = ['test/*_test.rb']
  p.summary = "a higher level diff application for analyzing changes to ruby code"
  p.extra_deps << ['ParseTree', '~> 3.0']
end
SPEC = HOE.spec


# Add some more dependencies to packaging:
task :package => ['git:update_manifest','git:update_manifest']

desc "Shows what has changed since the last commit"
namespace :git do
  task :changed do |t|
    _divider
    puts "Changes since last commit:"
    puts `./bin/ruby_diff --git HEAD --git-wd ./`
    _divider
  end
   
  desc "Updates the manifest to match the git repository"
  task :update_manifest do |t|
    `git ls-files > Manifest.txt`
  end
  
  desc "Pushes git repository out"
  task :push do |t|
    ['origin', 'rubyforge'].each do |source|
      puts "Pushing to #{source}..."
      puts `git push #{source}`
    end
  end
  
end

desc "Exports the gemspec for this project"
task :gemspec do |t|
  open("ruby_diff.gemspec",'w'){|io| io << SPEC.to_ruby}
end

namespace :github do
  desc "Simulates loading the Gem on GitHub"
  task :simulate_gem => :gemspec do |t|
    require 'rubygems/specification'
    data = File.read('ruby_diff.gemspec')
    spec = nil
    Thread.new { spec = eval("$SAFE = 3\n#{data}") }.join
    puts spec
  end
end

private
def _divider
  puts "-"*(ENV['COLUMNS'] || 80).to_i
end
