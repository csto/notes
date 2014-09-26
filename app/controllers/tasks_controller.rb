class TasksController < ApplicationController
  
  def create
    @task = Task.new(permitted_params)
    @task.save
    
    respond_to do |format|
      format.json {render json: @task}
    end
  end
  
  # def update
  #   @task = Task.find(params[:id])
  #   @task.update_attributes(permitted_params)
  #   head :ok
  # end
  #
  # def destroy
  #   @task = Task.find(params[:id])
  #   @task.destroy
  #   head :ok
  # end
  
  private
  
  def permitted_params
    params.require(:task).permit(:id, :note_id, :completed, :content, :position)
  end
end
