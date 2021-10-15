module CsvColumns
  class Price1
    class UnknowFileColumn < StandardError; end

    def self.[](file_column)
      file_column_to_db_column[file_column] || raise(UnknowFileColumn, file_column)
    end

    def self.file_column_to_db_column
      @file_column_to_db_column ||=
        {
          'Производитель' => 'brand',
          'Артикул' => 'code',
          'Количество' => 'stock',
          'Цена' => 'cost',
          'Наименование' => 'name'
        }
    end
  end
end
