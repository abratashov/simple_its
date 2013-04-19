class NotifyMailer < ActionMailer::Base
  include ApplicationHelper

  def send_confirmation(to, from, confirmation_uri, issue_uri)
    @to, @from = to, from
    @confirmation_uri, @issue_uri= confirmation_uri, issue_uri
    mail(:to => to, :from => from, :subject => "Simple Issue Tracking System: confirmation email")
  end

  def send_notify(to, from, message, sender_name, sender_email)
    @to, @frome, @message, @sender_name, @sender_email = to, from, message, sender_name, sender_email
    mail(:to => to, :from => from, :subject => "Simple Issue Tracking System: message from  #{sender_name}")
  end

end