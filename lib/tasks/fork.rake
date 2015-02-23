require 'fileutils'

desc 'Fork this starter to build a new project from it'
task :fork, :location do |_, args|
  location = args.location
  folder = to_folder_name location
  module_name = to_module_name folder
  project_string = module_name.downcase
  project_name = project_string.capitalize

  files = %w(
    README.md
    config/application.rb
    config/mongoid.yml
    config/initializers/session_store.rb
    config/locales/en.yml
    config/locales/fr.yml
  )

  FileUtils.cp_r Dir.pwd, location

  files.each do |file|
    full_path = "#{location}/#{file}"
    text = File.read full_path
    text = text.gsub(/funkystarterpp/, project_string)
    text = text.gsub(/Funkystarterpp/, project_name)
    text = text.gsub(/FunkyStarterPlusPlus/, module_name)
    File.open(full_path, 'w') { |f| f.puts text }
  end
end

def to_folder_name(str)
  str.split('/').last.downcase
end

def to_module_name(str)
  str.split('-').map(&:capitalize).join('')
end
