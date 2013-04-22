class AddIndexToMessageAndTicket < ActiveRecord::Migration
  def change
    add_index :messages, :body, :length => 255
    add_index :tickets, [:key, :subject]
  end
end
