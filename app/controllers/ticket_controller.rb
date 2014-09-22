class TicketController < ApplicationController
  def create
    @ticket = Ticket.new
  end

  def new
    @ticket = Ticket.new(ticket_params)
    @ticket.requests.new(request_params)

    if @ticket.save
      redirect_to view_ticket_path(@ticket.reference)
    else
      render action: 'create'
    end
  end

  def view
    @ticket = Ticket.find_by_reference(params[:hex])
  end

  def update
    @ticket = Ticket.find_by_reference(params[:hex])

    if @ticket and @ticket.status_id.in? [1, 2, 3]
      @request = @ticket.requests.new(request_params)

      if @ticket.save
        redirect_to view_ticket_path(@ticket.reference)
      else
        render action: 'view'
      end
    end
  end

  private

  def ticket_params
    params.require(:ticket).permit(:user_name, :email, :subject)
  end

  def request_params
    params.require(:ticket).require(:request).permit(:body)
  end
end
