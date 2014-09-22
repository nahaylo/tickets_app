ActiveAdmin.register Ticket do

  permit_params :user_id, :status_id

  scope :all
  scope :unassigned do
    Ticket.where(user_id: nil)
  end
  scope :open do
    Ticket.where(status_id: [1, 2])
  end
  scope 'On Hold' do
    Ticket.where(status_id: 3)
  end
  scope 'Closed' do
    Ticket.where(status_id: [4, 5])
  end

  filter :reference, as: :string
  filter :subject
  filter :requests_body, as: :string, label: 'Request'


  index do
    column 'Username', :user_name do |ticket|
      link_to ticket.user_name, admin_ticket_path(ticket.id)
    end
    column :email do |ticket|
      link_to ticket.email, admin_ticket_path(ticket.id)
    end
    column :subject do |ticket|
      link_to ticket.subject, admin_ticket_path(ticket.id)
    end
    column 'Status' do |ticket|
      ticket.status.title
    end
    column 'Request' do |ticket|
      link_to ticket.requests.last.body, admin_ticket_path(ticket.id) unless ticket.requests.empty?
    end

    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs 'Ticket info' do
      f.input :user
      f.input :status
    end

    f.actions
  end

  show do |ticket|
    columns do
      column do
        attributes_table do
          row :subject
          row :status do
            form_for ticket, url: {action: :update, id: ticket.id}, method: :patch do
              select_tag 'ticket[status_id]', options_from_collection_for_select(Status.all, 'id', 'title', ticket.status_id),
                         onchange: '$(this).parent("form").submit();'
            end
          end

          row 'Staff', :user do
            span do
              "#{ticket.user.email} |" if ticket.user
            end
            span do
              if ticket.user == current_user
                link_to 'Unassign!', unassign_admin_ticket_path
              else
                link_to 'Assign to me!', assign_admin_ticket_path
              end
            end
          end
        end
      end

      column do
        attributes_table do
          row :user_name
          row :email
          row :reference
          row :created_at
        end
      end

    end

    ticket.requests.each_with_index do |request, i|
      panel "Request ##{i}:" do
        panel "#{ticket.email} | #{request.created_at}:" do
          request.body
        end
        if request.reply
          panel "#{request.reply.user.email} | #{request.reply.created_at}:" do
            request.reply.body
          end
        else
          panel 'Just do it:' do
            form_for :ticket, url: replied_admin_ticket_path(request) do |f|
              f.fields_for :reply, ticket.replies.build do |r|
                r.text_area :body
                f.button :submit
              end
            end
          end
        end
      end
    end

  end

  member_action :replied, method: :post do
    reply = Reply.new(
        request_id: params[:id],
        body: params[:ticket][:reply][:body],
        user: current_user
    )

    if reply.save
      flash[:notice] = 'Replied!'
    else
      flash[:error] = reply.errors.full_messages.join(', ')
    end
    redirect_to action: :show, id: reply.ticket.id
  end

  member_action :assign do
    ticket = Ticket.find(params[:id])
    ticket.update_attributes(user: current_user)

    flash[:notice] = 'Ticket assigned to You!'
    redirect_to action: :show
  end

  member_action :unassign do
    ticket = Ticket.find(params[:id])
    ticket.update_attributes(user: nil)

    flash[:notice] = 'Ticket unassigned!'
    redirect_to action: :show
  end

end
