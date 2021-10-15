require './db_rake'
#
# https://github.com/rails/rails/blob/master/activerecord/lib/active_record/railties/databases.rake
#
namespace :db do
  desc "Migrate the database (options: VERSION=x, VERBOSE=false, SCOPE=blog)."
  task :migrate do
    DatabaseTasks.migrate
  end

  desc "Rolls the schema back to the previous version (specify steps w/ STEP=n)."
  task :rollback do
    step = ENV["STEP"] ? ENV["STEP"].to_i : 1
    ActiveRecord::Base.connection.migration_context.rollback(step)
  end
    
end
namespace :g do
  desc "Generate migration"
  task :migration do
    name = ARGV[1] || raise("Specify name: rake g:migration your_migration")
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    path = File.expand_path("../db/migrate/#{timestamp}_#{name}.rb", __FILE__)
    migration_class = name.split("_").map(&:capitalize).join

    File.open(path, 'w') do |file|
      file.write <<-EOF
        class #{migration_class} < ActiveRecord::Migration
          def self.up
          end
          def self.down
          end
        end
      EOF
    end
    abort # needed stop other tasks
  end
end
