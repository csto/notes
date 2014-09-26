class ImagesController < ApplicationController
  
  def create
    @note = Note.find(params[:note_id])
    @image = @note.images.build
    @image.file = params[:file]
    @image.save
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    head :ok
  end
  
  # private
  #
  # def permitted_params
  #   puts params
  #   params.require(:image).permit(:file)
  # end
  
end
