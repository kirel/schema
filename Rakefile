require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  require './lib/schema/version'
  Jeweler::Tasks.new do |gem|
    gem.name = "schema"
    gem.summary = %Q{Schemas for hashes}
    gem.description = %Q{Deep type conversion through schemas for hashes}
    gem.email = "danishkirel@gmail.com"
    gem.homepage = "http://github.com/kirel/schema"
    gem.authors = ["Daniel Kirsch"]
    gem.add_development_dependency "rspec", "~> 2.2"
    gem.add_development_dependency "yard", ">= 0"
    gem.version = Schema::VERSION    
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :spec => :check_dependencies
task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
