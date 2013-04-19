class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :id
      t.text :body
      t.integer :ticket_id
      t.integer :user_id
      t.boolean :is_send

      t.timestamps
    end
  end
end
