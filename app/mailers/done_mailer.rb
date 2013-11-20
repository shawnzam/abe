class DoneMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.done_mailer.done.subject
  #
  def done(parse)
    @greeting = "Job is done"
    @parse = parse
    mail to: "shawn@zamechek.com"
  end
end
