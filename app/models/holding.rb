require 'net/http'
require 'json'

class Holding < ActiveRecord::Base
  belongs_to :portfolio

  validates :symbol, presence: true
end
