require 'yaml'
require 'active_record'

db_config_file = File.open('config/database.yml')
db_config = YAML.load(db_config_file)
ActiveRecord::Base.configurations = db_config
ActiveRecord::Base.establish_connection(db_config['production'])
