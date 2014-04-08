require 'fwtoolkit/tasks'

FWToolkit::Rake.new_all

namespace :services do
  task :seed do
    # define any seeds to use with rake services:run here
    # t = TestObject.new
    # t.save!
  end
end

task :cruise => ["test:ci:frank"]
task :default => ["cruise"]
