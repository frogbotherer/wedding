class AddIsChildToRsvp < ActiveRecord::Migration
  def change
    add_column :rsvps, :is_child, :boolean
  end
end
