require 'securerandom'

class Ticket < ActiveRecord::Base
  attr_accessible :confirmation_key, :confirmed, :department_id, :id, :key, :owner_id, :status_id, :subject, :usermail, :username, :is_send

  has_many :messages
  belongs_to :status
  belongs_to :department
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id

  validates_presence_of :username
  validates_presence_of :usermail
  validates_format_of :usermail, :with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i
  #:format => {:with => /^$|^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}

  #after_save { Resque.enqueue(ConfirmNotify, id) }
  after_save { Resque.enqueue(TicketNotify, id) }

  scope :get_by_subject, lambda { |s|
    { :conditions => [" subject REGEXP ? ", s] }
  }

  def self.to_save hash_ticket, department_id, body, user
    result = nil
    ticket = new hash_ticket
    ticket.department_id = department_id
    ticket.confirmed = false
    ticket.confirmation_key = SecureRandom.hex 16
    ticket.status_id = Status.default
    ticket.is_send = false
    if ticket.save
      Resque.enqueue(ConfirmNotify, ticket.id)
      ticket.update_attributes({key: generate_key(ticket)})
      message = Message.to_save body, ticket.id, user
      result = [ticket, message]
    end
    result
  end

  def self.to_update id, status_id, owner_id, body, user
    ticket = Ticket.find_by_id id
    if ticket && ticket.update_attributes({status_id: status_id, owner_id: owner_id})
      message = Message.to_save body, ticket.id, user
      return [ticket, message]
    end
  end

  def confirm!
    p 'confirm!'
    p self
    #if !confirmed
      p 'here------------------------'
      update_attributes({confirmed: true})
      #Resque.enqueue(TicketNotify, id)
    #end
    true
  end

  def self.send_confirmation(ticket)
    to = ticket.usermail
    confirmation_uri = generate_confirm_uri(ticket)
    issue_uri = generate_issue_uri(ticket)
    from = ActionMailer::Base.smtp_settings[:user_name] + '@' + ActionMailer::Base.smtp_settings[:domain]
    if NotifyMailer.send_confirmation(to, from, confirmation_uri, issue_uri).deliver
      ticket.update_attributes({:is_send => true})
    end
  end


  # class << self
    # def send_notification(notify)
      # user, message = notify.user, notify.message
      # UserType.find_by_name('admin').users.each do |admin|
        # to = admin.email
        # sender_name = user.name
        # sender_email = user.email
        # from = ActionMailer::Base.smtp_settings[:user_name] + '@' + ActionMailer::Base.smtp_settings[:domain]
        # if !admin.email.empty?
          # if NotifyMailer.send_notify(to, from, message, sender_name, sender_email).deliver
            # notify.update_attributes({:is_send => true})
          # end
        # end
      # end
    # end
  # end

  private

  def self.generate_key ticket
    'AAA-' + ticket.id.to_s
  end

  def self.generate_confirm_uri ticket
    "http://#{HOME_URL}/confirm/#{ticket.confirmation_key}"
  end

  def self.generate_issue_uri ticket
    "http://#{HOME_URL}/tickets/#{ticket.id}"
  end
end
