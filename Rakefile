$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

begin
  require 'rake'
  require 'spec/rake/spectask'
rescue LoadError
  require 'rubygems'
  retry
end

require 'haplocheirus/version'

task :default => :spec

desc 'Run all specs in spec/'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc 'Build the gem'
task :build do
  system "gem build haplocheirus-client.gemspec"
end
