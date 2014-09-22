class Reply < ActiveRecord::Base
  belongs_to :request
  belongs_to :user
  has_one :ticket, through: :request

  validates_presence_of :body

  after_create :assign_ticket, :update_ticket_status, :send_email, :add_log

  private

  def assign_ticket
    self.ticket.update_attributes(user: self.user)
  end

  def update_ticket_status
    self.ticket.update_attributes(status: Status.for_customer)
  end

  def send_email
    TicketMailer.replied(self.ticket).deliver
  end

  def add_log
    logger.info "Created new reply: #{self.body}"
    logger.debug self.attributes.to_s
  end
end
