class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery
  
  respond_to :html, :json
  
  before_filter :set_token
  
  private
  
  def set_token
    puts "PARAMS: #{params}"
    if params[:user] && params[:user][:token]
      cookies[:token] = params[:user][:token]
    end
  end
end
