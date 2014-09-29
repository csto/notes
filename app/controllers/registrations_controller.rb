class RegistrationsController < Devise::RegistrationsController
  after_filter :create_user_note, only: [:create]
  
  private
  
  def create_user_note
    puts current_user
    
    if cookies[:token]
      token = cookies[:token]
      cookies.delete(:token)
      @share_token = ShareToken.find_by_token(token)
      @user_note = @share_token.note.user_notes.build
      @user_note.user = current_user
      @user_note.save
      # @share_token.destroy
    end
  end
end