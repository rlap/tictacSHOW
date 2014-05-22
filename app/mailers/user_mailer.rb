class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def challenge_invitation(user, invitee, game)
    @user = user
    @game = game
    mail(to: invitee.email, subject: "Accept the challenge?")
  end
end
