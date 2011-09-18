require_relative '../lib/skeletor/templates'
require_relative '../lib/skeletor/builder'

path = File.expand_path(File.join(File.dirname(__FILE__), "test_project"))

skeleton = Skeletor::Builder.new('test_project','js-lib',path)
#skeleton = Skeletor::Templates::Skeleton.new('js-lib')
#skeleton = YAML.load_file(File.join(Skeletor::Templates::Loader::TEMPLATE_PATH,'js-lib/js-lib.yml'))

#puts skeleton.directory_structure.empty?()
#skeleton.directory_structure.each_pair{
#  |dir,content|
#  
#  puts dir
#}

skeleton.build()
