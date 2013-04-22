class Message < ActiveRecord::Base
  attr_accessible :body, :id, :ticket_id, :user_id, :is_send

  belongs_to :ticket
  belongs_to :user

  validates_presence_of :body

  after_save { Resque.enqueue(TicketNotify, id) }

  scope :get_by_keyword, lambda { |k|
    { :conditions => [" body REGEXP ? ", k] }
  }

  def self.to_save body, ticket_id, user
    user_id = user ? user.id : nil
    message = new({body: body, ticket_id: ticket_id, user_id: user_id, is_send: false})
    message.save
    message
  end

  def send_message
    to = ticket.usermail
    body = body
    issue_uri = Ticket.generate_issue_uri ticket
    from = ActionMailer::Base.smtp_settings[:user_name] + '@' + ActionMailer::Base.smtp_settings[:domain]
    if NotifyMailer.send_message(to, from, body, issue_uri, self).deliver
      update_attributes({:is_send => true})
    end
    recipients = ticket.department.users
    if recipients
      recipients.each {|recipient| NotifyMailer.send_message(recipient.email, from, body, issue_uri, self).deliver}
    end
  end
end
