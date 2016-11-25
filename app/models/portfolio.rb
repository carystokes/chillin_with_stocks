class Portfolio < ActiveRecord::Base
  belongs_to :user
  has_many :holdings, dependent: :destroy

  validates :title, presence: true
end
