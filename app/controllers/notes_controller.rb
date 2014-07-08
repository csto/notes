class NotesController < ApplicationController
  
  def index
    @q = Note.search(params[:q])
    if params[:q].present? && params[:q][:archived_eq].present?
      @notes = @q.result.where(archived: true)
    else
      @notes = @q.result.where(archived: false)
    end
  end
  
  def create
    @note = Note.new(permitted_params)
    @note.save
    
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
    head :ok
  end
  
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
