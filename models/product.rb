class Product < ActiveRecord::Base
  validates :brand, :stock, :cost, :code, presence: true
end
