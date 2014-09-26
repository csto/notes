class UserNotesController < ApplicationController
  
  def new
    @user = User.find_by_email(params[:email])
    @note = Note.find(params[:id])
    if @user
      @user_note = @user.user_notes.build
      @user_note.note = @note
      @user_note.save
    else
      token = SecureRandom.urlsafe_base64
      @share_token = @note.share_tokens.build
      @share_token.token = token
      # UserMailer.share_note_email(params[:email], token).deliver
    end
  end
  
end
