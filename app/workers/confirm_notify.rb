class ConfirmNotify
  @queue = :confirm_serve

  def  self.perform(id)
    tickets = Ticket.where("is_send = #{false}")
    tickets.each{|ticket| p ticket; Ticket.send_confirmation(ticket)}
  end
end