class TicketNotify
  @queue = :notify_serve

  def self.perform(id)
    sleep 5
    messages = Message.where("is_send = #{false}")
    messages.each{|message| p message.ticket.confirmed; message.send_message if message.ticket.confirmed}
  end
end