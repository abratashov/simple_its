class NotifyMailer < ActionMailer::Base
  #include ApplicationHelper

  def send_confirmation(to, from, confirmation_uri, issue_uri)
    @to, @from = to, from
    @confirmation_uri, @issue_uri= confirmation_uri, issue_uri
    mail(:to => to, :from => from, :subject => "Simple Issue Tracking System: confirmation email")
  end

  def send_message(to, from, confirmation_uri, issue_uri, message)
    @to, @from = to, from
    @sender = message.user ? message.user.name : message.ticket.username
    @body, @issue_uri = message.body, issue_uri
    mail(:to => to, :from => from, :subject => "Simple Issue Tracking System: #{message.ticket.key} #{message.ticket.subject}")
  end

end