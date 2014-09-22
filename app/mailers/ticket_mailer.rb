class TicketMailer < ActionMailer::Base
  default from: 'notifications@tickets.com'

  def new_ticket(ticket)
    @ticket = ticket
    mail(to: @ticket.email, subject: 'Created new ticket')
  end

  def replied(ticket)
    @ticket = ticket
    mail(to: @ticket.email, subject: 'Ticket replied')
  end
end
