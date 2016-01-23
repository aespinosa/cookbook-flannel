require 'rake/testtask'
require 'rubocop/rake_task'

Rake::TestTask.new do |t|
  t.libs = %w(libraries)
  t.test_files = FileList['test/unit/*_test.rb']
  t.verbose = true
end

RuboCop::RakeTask.new

task default: %w(test rubocop)
