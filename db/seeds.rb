# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

# set up admin users
cw = User.new
cw_rsvp = Rsvp.new
cw_rsvp.name = 'Chris'
cw.username = 'cw'
cw.email = 'x@x.x'
cw.id = 1
cw.rsvps << cw_rsvp
cw.save
