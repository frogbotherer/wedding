class CreateRsvps < ActiveRecord::Migration
  def change
    create_table :rsvps do |t|
      t.references :user
      t.string :name
      t.string :attending
      t.string :meal
      t.string :dietreqs
      t.text :notes

      t.timestamps
    end
  end
end
