require 'bundler'
Bundler::GemHelper.install_tasks
require 'rake/rdoctask'
ENV["RDOC_OPTS"] ||= "-c UTF-8"
Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "History.rdoc", "lib/**/*.rb")
  rd.options << "--charset" << "UTF-8"
end
