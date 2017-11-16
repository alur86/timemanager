class Event < ApplicationRecord
has_many :attendances
has_many :users, :through => :attendances

belongs_to :users, class_name: "User",  optional: true
validates :title, :place, :description, presence: true




  def event_owner(user_id)
    User.find_by id: user_id
  end

  def show_my_events(user_id)
    Event.where(user_id: user_id)
  end


 def created_by_user?(user)
    user_id == user.id
  end


  def pending_requests(event_id)
    Attendance.pending.where(event_id: event_id)
  end
  
  def show_accepted_attendees(event_id)
    Attendance.accepted.where(event_id: event_id)
  end


def self.pending_requests(event_id)
Attendance.where(event_id: event_id, state:
'The request_sent')
end

end
