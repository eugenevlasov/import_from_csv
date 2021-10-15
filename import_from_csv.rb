require './db_initializer'
require './models/product'

require 'activerecord-import'
require './lib/csv_columns/price_1'
require './lib/csv_columns/price_2'
require './lib/csv_columns/price_3'
require './lib/price_list_updater'
ActiveRecord::Import.require_adapter('postgresql')

configs = [
  OpenStruct.new(name: 'price_1',
                 columns: CsvColumns::Price1.file_column_to_db_column,
                 separator: ',',
                 model: Product),
  OpenStruct.new(name: 'price_2',
                 columns: CsvColumns::Price2.file_column_to_db_column,
                 separator: ';',
                 model: Product),
  OpenStruct.new(name: 'price_3',
                 columns: CsvColumns::Price3.file_column_to_db_column,
                 separator: ';',
                 encoding: 'windows-1251',
                 model: Product)
]
configs.each do |price|
  puts "Обновляем #{price.name}"
  PriceListUpdater.new(price).call
end
