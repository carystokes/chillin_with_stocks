class Portfolio < ActiveRecord::Base
  belongs_to :user
  has_many :holdings, dependent: :destroy

  def initialize(title, cash)
    @title = title
    @cash = cash
    @holdings = self.holdings
  end
  
  validates :title, presence: true
end
