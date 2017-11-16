class EventsController < ApplicationController
require "round_robin_tournament"

before_action :authenticate_user!, only: [:new, :index,:edit, :create, :update, :destroy]





   def index
   @events = Event.all
   end


  def new
    @event = Event.new
  end


  def edit
  end



  def show
    @event = Event.find_by(id: params[:id])
     @pending_requests = Attendance.pending.where(event_id: @event.id)
    @attendees = Attendance.accepted.where(event_id: @event.id)
  end



def my_events
    @event = Event.find(current_user.id)
  end

  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end


  def join
  @attendance = Attendance.join_event(current_user.id,
  params[:event_id], 'request_sent')
  'Request just sent you' if @attendance.save
  respond_with @attendance
  end

    def accept_request
    @event = Event.find(params[:event_id])
    @attendance = Attendance.find_by(id: params[:attendance_id]) rescue nil
    @attendance.accept!
    'Applicant Accepted' if @attendance.save
    respond_with(@attendance)  
    respond_to do |format|
      if @attendance.save
         format.html { redirect_to(@event, :notice => 'Accepted Applicant') }
         format.xml  { head :ok }
       else
        format.html { redirect_to(events_path, :notice => 'Something has gone wrong , please try again.') }
         format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
     end
    
  end
  




  def reject_request
    @event = Event.find(params[:event_id])
    @attendance = Attendance.where(params[:attendance_id]) rescue nil
    @attendance.reject!
    'Applicant Rejected' if @attendance.save
    respond_with(@attendance)
    
     respond_to do |format|
      if @attendance.save
         format.html { redirect_to(@event, :notice => 'Rejected Applicant') }
        format.xml  { head :ok }
      else
        format.html { redirect_to(events_path, :notice => 'Something has gone wrong , please try again.') }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
     end
  end



  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end 

def create
@event = current_user.events.new(event_params)
user_scheduler(current_user.id)
respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
end


private

def event_owner
   if @event.user_id != current_user.id
	redirect_to events_path
	 flash[:notice] = 'You do not have enough permissions to do this'
      end
 end

def set_event
    @event = current_user.events.find_by(id: params[:id])
end


def user_scheduler(user_id)
user = %w(current_user.email)
started = RoundRobinTournament.schedule(user)
end


def event_params
  params.require(:event).permit(:title, :user_id, :start_date, :due_date, :place,:description)
end


end
