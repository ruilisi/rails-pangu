# frozen_string_literal: true

module UtilMailgun
  class << self
    def send_template(template_name, recipient_or_receipients, subject, variables = {})
      mg_client = Mailgun::Client.new(ENV['MAILGUN_PRIVATE_API_KEY'])
      mb = Mailgun::MessageBuilder.new
      mb.template(template_name)
      mb.from(ENV['MAILGUN_EMAIL_FROM'])
      mb.subject(subject)
      if recipient_or_receipients.is_a?(Array)
        recipient_or_receipients.each do |recipient|
          mb.add_recipient(:to, recipient)
        end
      else
        mb.add_recipient(:to, recipient_or_receipients)
      end
      mb.header('X-Mailgun-Variables', variables)
      mg_client.send_message(ENV['MAILGUN_DOMAIN'], mb).to_h!
    end

    def send_email(from_name, to_name, subject, text)
      mg_client = Mailgun::Client.new(ENV['MAILGUN_PRIVATE_API_KEY'])
      message_params = {
        from: from_name,
        to: to_name,
        subject: subject,
        text: text
      }
      mg_client.send_message(ENV['MAILGUN_DOMAIN'], message_params).to_h!
    end
  end
end
