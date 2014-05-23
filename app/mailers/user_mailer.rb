class UserMailer < ActionMailer::Base
  default from: "rose.la.prairie@gmail.com"

  def challenge_invitation(user, invitee, game)
    @user = user
    @game = game
    @invitee = invitee
    mail(to: invitee.email, subject: "Accept the challenge?")
  end

  def challenge_invitation_already_user(user, invitee, game)
    @user = user
    @game = game
    mail(to: invitee.email, subject: "Accept the challenge?")
  end
end
