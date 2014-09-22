class Request < ActiveRecord::Base
  belongs_to :ticket
  has_one :reply

  validates_presence_of :body

  after_create :update_ticket_status

  private

  def update_ticket_status
    self.ticket.update_attributes(status: Status.for_staff)
  end
end
