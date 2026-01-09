class Customer::EventsController < ApplicationController
  before_action :require_customer

  def index
    # Only show events created by admins (assuming admin role is 'admin')
    @events = Event.joins(:creator).where(users: { role: 'admin' })
  end

  def show
    @event = Event.find(params[:id])
    @ticket_types = @event.ticket_types
  end
end