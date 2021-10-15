require 'ostruct'
require 'pathname'
require 'yaml'
require 'active_record'
require 'pg'
require './db_initializer'

Rails = OpenStruct.new
root = Pathname.new(File.expand_path(__dir__))
Rails.root = root
env = ActiveSupport::StringInquirer.new('production')
Rails.env = env

include ActiveRecord::Tasks
DatabaseTasks.env = env
ActiveRecord::Tasks::DatabaseTasks.database_configuration = ActiveRecord::Base.configurations
DatabaseTasks.db_dir = root.join('db').to_s
migrations_paths = []
migrations_paths.push root.join('db/migrate').to_s if File.exist?(root.join('db/migrate').to_s)
DatabaseTasks.migrations_paths = migrations_paths
DatabaseTasks.root = root

DatabaseTasks.create_current
