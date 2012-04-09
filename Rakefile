require 'rubygems'
require 'bundler'
Bundler::GemHelper.install_tasks
require 'rdoc'
require 'rdoc/task'

ENV["RDOC_OPTS"] ||= "-c UTF-8"
RDoc::Task.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "History.rdoc", "lib/**/*.rb")
  rd.options << "--charset" << "UTF-8"
end

task :default => :rdoc
