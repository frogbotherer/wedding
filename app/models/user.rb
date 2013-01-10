class User < ActiveRecord::Base

  has_many :rsvps

  attr_readonly   :username
  attr_accessible :email, :password, :password_confirmation, :rsvps
  authenticates_with_sorcery!

  validates_length_of :password, :minimum => 4, :message => "must be at least 4 characters long", :if => :password
  validates_confirmation_of :password, :message => "should match confirmation", :if => :password

  validates :username, :uniqueness => true
  validates :email, :format => { :with => /^.+\@.+$/, :message => "must be a valid" }, :if => "!email.nil? and email.length > 0"

  def is_admin?
    id == 1
  end

  def fullname
    i = rsvps.length

    if (rsvps.reduce false do |haskids,rsvp| haskids ||= rsvp.is_child? end) && !rsvps[0].is_child? then
      rsvps[0].name + " and Family"
    else
      rsvps.map do |rsvp| { :index => i-=1, :name => rsvp.name } end.
        reduce "" do |fullname,rsvp|
          fullname += if rsvp[:name].nil? then "Guest" else rsvp[:name] end + 
                      case rsvp[:index] when 0 then "" when 1 then " and " else ", " end
        end
    end
  end

  def state
    if !is_valid_email? then
      :update_email
    elsif !has_confirmed? then
      :confirm_rsvp
    else
      :wait_for_menu
    end
  end

  def next_action
    case state
      when :update_email then "Please provide your e-mail address so that we can keep you informed"
      when :confirm_rsvp then "Please complete the RSVP sections below"
      when :wait_for_menu then "See \"Further Information\" above"
      else ""
    end
  end

  def is_valid_email?
    if !self[:email].nil? && self[:email].match( /^.+\@.+$/ ) then true else false end     # want to return a boolean
  end

  def has_confirmed?
    rsvps.reduce true do |state,rsvp| state &&= rsvp.attending != "Unsure" end
  end

  def generate_username
    r = rand 10000
    a = ((r + 3103) % 26 + 97).chr
    "%s%04d" % [a,r]
  end
end
