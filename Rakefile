require 'bundler/gem_tasks'
load './lib/tasks/validate.rake'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

task(default: [:spec, :rubocop])
