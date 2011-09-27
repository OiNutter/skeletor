require 'skeletor/version'

# Base module for gem.
module Skeletor
  autoload :Skeletons, 'skeletor/skeletons'
  autoload :Tasks, 'skeletor/tasks'
  autoload :Builder, 'skeletor/builder'
  autoload :Includes, 'skeletor/includes'
  autoload :CLI, 'skeletor/cli'
end
