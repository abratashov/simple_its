class TicketsController < ApplicationController
  before_filter :require_login, :except => [:new, :create, :confirm, :show, :update]

  def index
    p 'current_user=================='
    p current_user
    @tickets = current_user.department.tickets
    render
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
    @ticket = Ticket.to_update params[:id], params[:status_id], params[:owner_id], params[:body], current_user
    render action: 'show'
  end

end
