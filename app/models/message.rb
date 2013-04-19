class Message < ActiveRecord::Base
  attr_accessible :body, :id, :ticket_id, :user_id, :is_send

  belongs_to :ticket
  belongs_to :user

  def self.to_save body, ticket_id, user
    user_id = user ? user.id : nil
    message = new({body: body, ticket_id: ticket_id, user_id: user_id, is_send: false})
    message.save
  end
end
