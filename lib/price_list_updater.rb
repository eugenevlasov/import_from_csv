require 'CSV'
class PriceListUpdater
  attr_reader :config, :encoding

  delegate :name, :columns, :model, :separator, to: :config

  def initialize(config)
    @config = config
    @encoding = config.encoding
  end

  def call
    update
  end

  def update
    data = []
    read_data do |row|
      row = strip_row(row)
      next unless correct_row?(row)

      data << row.to_h.compact.merge('price_list' => name)
    end
    import_ids = import(data)
    delete_unused(import_ids)
  end

  private

  def read_data(&block)
    CSV.foreach(filename,
                params_for_csv, &block)
  end

  def params_for_csv
    prms = { headers: true,
             col_sep: separator,
             liberal_parsing: true,
             header_converters: ->(h) { columns[h] || unknown_key_name } }
    if encoding
      prms[:external_encoding] = encoding
      prms[:internal_encoding] = 'utf-8'
    else
      prms[:encoding] = 'bom|utf-8'
    end
    prms
  end

  def strip_row(row)
    row.delete_if { |k, _v| k == unknown_key_name }

    row['stock']&.gsub!('>', '')
    row['stock']&.strip!
    row['cost']&.strip!
    row['brand']&.strip!

    row
  end

  def import(data)
    res = model.import!(data,
                        on_duplicate_key_update: {
                          conflict_target: ['price_list', 'lower(brand::text)', 'lower(code::text)'],
                          columns: :all
                        })
    puts "#{name}: Загружено #{res.ids.count}"
    res.ids
  end

  def delete_unused(ids)
    model.where(price_list: name).where.not(id: ids).delete_all
  end

  def filename
    "./data/#{name}.csv"
  end

  def unknown_key_name
    __method__
  end

  def correct_row?(row)
    row['brand'].present? && row['cost'].present? && row['stock'].present? && row['code'].present?
  end
end
