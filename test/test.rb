require_relative '../lib/skeletor/skeletons/loader'
require_relative '../lib/skeletor/skeletons/validator'
require_relative '../lib/skeletor/skeletons/skeleton'

require_relative '../lib/skeletor/builder'

path = File.expand_path(File.join(File.dirname(__FILE__), "test-template"))

#skeleton = Skeletor::Builder.new('test_project','js-lib',path)
#skeleton = Skeletor::Templates::Skeleton.new('js-lib')
#skeleton = YAML.load_file(File.join(Skeletor::Templates::Loader::TEMPLATE_PATH,'js-lib/js-lib.yml'))

#puts skeleton.directory_structure.empty?()
#skeleton.directory_structure.each_pair{
#  |dir,content|
#  
#  puts dir
#}
skeleton = Skeletor::Skeletons::Loader.loadTemplate(path)
validator = Skeletor::Skeletons::Validator.new(skeleton)
validator.validate()
