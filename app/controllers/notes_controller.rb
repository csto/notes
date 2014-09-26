class NotesController < ApplicationController
  
  def index
    @notes = current_user.notes.includes(:tasks, :images).order('position ASC, created_at DESC')
  end
  
  def create
    @note = current_user.notes.create(permitted_params)
    
    respond_to do |format|
      format.json {render json: @note.to_json(include: :tasks)}
    end
  end
  
  def show
    @note = Note.find(params[:id])
    
    respond_to do |format|
      format.json {render json: @note.to_json(include: :tasks)}
    end
  end
  
  def update
    @note = Note.find(params[:id])
    @note.update_attributes(permitted_params)
    
    respond_to do |format|
      format.json {render json: @note.to_json(include: :tasks)}
    end
  end
  
  # def upload
  #   @note = Note.find(params[:id])
  #   @image = @note.images.build(params[:image])
  #   @image.save
  #   head :ok
  # end
  
  def archive
    @note = Note.find(params[:id])
    @note.archived = true
    @note.save
    head :ok
  end
  
  def destroy
    @note = Note.find(params[:id])
    @note.destroy
    head :ok
  end
  
  private
  
  def permitted_params
    params[:note][:tasks_attributes] = params[:note][:tasks]
    params.require(:note).permit(:position, :kind, :title, :content, :color, {tasks_attributes: [:id, :content, :completed, :position, :_destroy]})
  end
end
