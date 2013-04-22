class TicketsController < ApplicationController
  before_filter :require_login, :except => [:new, :create, :confirm, :show, :update, :index]

  def index
    if current_user
      if params[:search]
        @tickets = []
        ticket = Ticket.find_by_key(params[:search])
        @tickets << ticket if ticket
        tickets = Ticket.get_by_subject(params[:search])
        @tickets += tickets
        messages = Message.get_by_keyword(params[:search])
        messages.each{|m| @tickets << m.ticket}
        @tickets = @tickets.uniq {|t| t.id}
      else
        @tickets = case params[:status]
          when 'mytickets'
            current_user.department.tickets.find_all{|t| t.owner_id == current_user.id}
          when 'unassigned'
            current_user.department.tickets.find_all{|t| t.owner_id.nil?}
          when 'open'
            current_user.department.tickets.find_all{|t| t.owner}
          when 'hold'
            status = Status.get_by('hold').first
            current_user.department.tickets.find_all{|t| t.status_id == status.id}
          when 'completed'
            status = Status.get_by('completed').first
            current_user.department.tickets.find_all{|t| t.status_id == status.id}
          else
            !current_user.nil? ? current_user.department.tickets.find_all{|t| t.owner_id == current_user.id} : []
        end
      end
      render
    else
      redirect_to :action => 'new'
    end
  end

  def show
    @ticket = params[:key] ? Ticket.find_by_key(params[:key]) : Ticket.find_by_id(params[:id])
    render
  end

  def new
    @ticket = Ticket.new
    render
  end

  def create
    @ticket = Ticket.new params[:ticket]
    if Ticket.to_save params[:ticket], params[:department_id], params[:body], current_user
      flash.now.alert = 'Ticket created, check your email for confirmation.'
      @ticket = Ticket.new
    else
      flash.now.alert = 'Error during saving ticket.'
    end
    render 'tickets/new'
  end

  def confirm
    @ticket = Ticket.find_by_confirmation_key params[:conf_key]
    if @ticket && @ticket.confirm!
      render 'tickets/show'
    else
      render 'tickets/new'
    end
  end

  def update
    p 'update----------------------------------'
    @ticket, @message = Ticket.to_update params[:id], params[:status_id], params[:owner_id], params[:body], current_user
    p @ticket
    p @message
    render action: 'show'
  end

end
