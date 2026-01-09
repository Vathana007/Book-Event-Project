class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :require_admin

  # GET /events
  def index
    if params[:q].present?
      query = params[:q]
      @events = Event.where("CAST(id AS TEXT) ILIKE ? OR title ILIKE ?", "%#{query}%", "%#{query}%")
    else
      @events = Event.all
    end
  end

  # GET /events/:id
  def show
    @event = Event.find(params[:id])
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/:id/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  def create
    @event = Event.new(event_params)
    # Set default user 
    @event.created_by = 2
    if @event.save
      redirect_to events_path, notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /events/:id
  def update
    if @event.update(event_params)
      redirect_to events_path, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /events/:id
  def destroy
    @event.destroy
    redirect_to events_path, notice: 'Event was successfully destroyed.'
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :location, :price, :available_tickets, :start_time, :end_time, :image, :category_id, :created_by)
  end
end