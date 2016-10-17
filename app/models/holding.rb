class Holding < ActiveRecord::Base
  belongs_to :portfolio

  validates :symbol, presence: true
end
