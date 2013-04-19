module TicketsHelper
  def render_message msg
    ("<div>#{msg.gsub(/\n/, '<br>')}</div>").html_safe
  end

  def status_helper
    select_tag 'status_id', options_from_collection_for_select(Status.find(:all).map{|u| [u.id, u.name]}, :first, :last, @ticket.status_id.to_s)
  end

  def owner_helper
    p 'owner_helper'
    p @ticket
    selected = @ticket.owner_id ? @ticket.owner_id : nil
    select_tag 'owner_id', options_from_collection_for_select(@ticket.department.users.map{|u| [u.id, u.email]}, :first, :last, selected), :include_blank => true
  end
  
  def render_owner ticket
    ticket.owner_id ? ticket.owner.name : ''
  end
end
