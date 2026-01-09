class TicketTypesController < ApplicationController
  before_action :set_event
  before_action :set_ticket_type, only: [:show, :edit, :update, :destroy]
  before_action :require_admin


  def index
    if params[:q].present?
      query = params[:q].downcase
      @ticket_types = @event.ticket_types.where("LOWER(name) LIKE ?", "%#{query}%")
    else
      @ticket_types = @event.ticket_types
    end
  end

  def show
    @ticket_type = @event.ticket_types.find(params[:id])
  end

  def new
    @ticket_type = @event.ticket_types.build
  end

  def create
    @ticket_type = @event.ticket_types.build(ticket_type_params)
    if @ticket_type.save
    redirect_to event_ticket_types_path(@event), notice: "Ticket type created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @ticket_type.update(ticket_type_params)
    redirect_to event_ticket_types_path(@event), notice: "Ticket type updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @ticket_type.destroy
    redirect_to event_ticket_types_path(@event), notice: "Ticket type deleted."
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_ticket_type
    @ticket_type = @event.ticket_types.find(params[:id])
  end

  def ticket_type_params
    params.require(:ticket_type).permit(:name, :price, :available_tickets)
  end
end