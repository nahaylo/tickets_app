class Status < ActiveRecord::Base
  has_many :tickets

  def self.for_staff
    Status.find(1)
  end

  def self.for_customer
    Status.find(2)
  end
end
