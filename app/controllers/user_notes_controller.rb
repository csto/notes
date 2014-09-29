class UserNotesController < ApplicationController
  
  def create
    @note = Note.find(params[:note_id])
    @user = User.find_by_email(params[:email])
    if @user
      @user_note = @user.user_notes.build
      @user_note.note = @note
      @user_note.save
    else
      token = SecureRandom.urlsafe_base64
      @share_token = @note.share_tokens.build
      @share_token.token = token
      @share_token.save
      UserMailer.share_note_email(current_user, params[:email], token).deliver
    end
    head :ok
  end
  
end
