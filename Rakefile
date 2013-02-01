require "bundler/gem_tasks"
require "rake/testtask"

task :default => "test:unit"

Rake::TestTask.new do |t|
  t.name = "test:all"
  t.pattern = "test/**/*_test.rb"
end

Rake::TestTask.new do |t|
  t.name = "test:unit"
  t.pattern = "test/unit/**/*_test.rb"
end

Rake::TestTask.new do |t|
  t.name = "test:integration"
  t.pattern = "test/integration/**/*_test.rb"
end
