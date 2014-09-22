class Request < ActiveRecord::Base
  belongs_to :ticket
  has_one :reply

  validates_presence_of :body
end
