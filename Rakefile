require 'rake'
require 'rake/testtask'

task :default => "git:changed"

desc "Run tests"
Rake::TestTask.new("test") do |t|
  t.pattern = 'test/*_test.rb'
  t.verbose = false
  t.warning = true
end

desc "Shows what has changed since the last commit"
namespace :git do
  task :changed do |t|
    puts `./bin/ruby_diff --git HEAD --file ./`
  end
end
