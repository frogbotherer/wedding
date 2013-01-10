#!/usr/local/rvm/rubies/ruby-1.9.2-p0/bin/ruby

require File.expand_path('../../config/environment', __FILE__)
require 'csv'

# don't overwrite contents of database!
#if User.find(1) then exit

#CSV::Reader.parse(File.open(ARGV[0],'rb'),',') do |row|
CSV.foreach ARGV[0] do |row|
  next if row[0] == "Invite Code" # skip headers
  p row
  username = row[0]
  rsvpname = row[1]
  ischild  = row[2] == "Y"

  # attempt to fetch user; create if nil
  u = User.where(:username => username).first || User.new
  u.username = username

  # create rsvp
  r = Rsvp.new
  r.name = rsvpname
  r.is_child = ischild
  u.rsvps << r

  # save the lot
  if !u.save then
    p "User #{u.username} had errors!"
    p u.errors
    exit
  end

  if !r.save then
    p "RSVP #{r.name} had errors!"
    p r.errors
    exit
  end

  p "User #{u.username}; RSVP #{r.name} ... ADDED"
end
