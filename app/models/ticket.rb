class Ticket < ActiveRecord::Base
  belongs_to :user
  belongs_to :status
  has_many :requests
  has_many :replies, through: :requests

  accepts_nested_attributes_for :requests
  validates_presence_of :user_name, :email, :subject
  validates_email_format_of :email, :message => 'is not looking good'

  before_create :generate_reference
  before_create :set_status

  after_create :send_email

  private

  def generate_reference
    f = SecureRandom.hex(2)[0..2]
    s = SecureRandom.hex(1)
    t = SecureRandom.hex(1)
    self.reference = "#{f}-#{s}-#{f}-#{t}-#{f}"
  end

  def set_status
    self.status = Status.find(1)
  end

  def send_email
    TicketMailer.new_ticket(self).deliver
  end
end
