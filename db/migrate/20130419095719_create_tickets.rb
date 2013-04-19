class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.integer :id
      t.string :key
      t.string :subject
      t.integer :status_id
      t.string :username
      t.string :usermail
      t.integer :department_id
      t.integer :owner_id
      t.boolean :confirmed
      t.string :confirmation_key
      t.boolean :is_send

      t.timestamps
    end
  end
end
