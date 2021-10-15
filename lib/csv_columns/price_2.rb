module CsvColumns
  class Price2
    class UnknowFileColumn < StandardError; end

    def self.[](file_column)
      file_column_to_db_column[file_column] || raise(UnknowFileColumn, file_column)
    end

    def self.file_column_to_db_column
      @file_column_to_db_column ||=
        {
          'Бренд' => 'brand',
          'Артикул' => 'code',
          'Количество' => 'stock',
          'Цена' => 'cost',
          'НаименованиеТовара' => 'name'
        }
    end
  end
end
