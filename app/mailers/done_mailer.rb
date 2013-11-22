class DoneMailer < ActionMailer::Base
  default from: 'from@example.com'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.done_mailer.done.subject
  #
  def done(parse)
    @greeting = "Job is done"
    @parse = parse
    attachments[parse.result_f_file_name] = File.read(parse.result_f.path)
    mail to: "zamechek@wharton.upenn.edu", from: "shawnzam@gmail.com", subject: "foof"
    
    # attachments[report.pdf_file_file_name] = File.read(report.pdf_file.path)
  end
end
