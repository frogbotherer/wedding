class Rsvp < ActiveRecord::Base

  attr_accessible :name, :notes, :attending, :is_child

  validates :attending,     :inclusion => { :in => [ "Yes", "No", "Unsure" ] }

  def name=( newname )
    self[:name] = if newname == "" then nil else newname end
  end

  def is_attending?
    attending == "Yes"
  end

  def attending
    if self[:attending].nil? then "Unsure" else self[:attending] end
  end

  # prettier accessors
  def is_child?
    self[:is_child]
  end

  belongs_to :user
end
