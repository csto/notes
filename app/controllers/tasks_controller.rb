class TasksController < ApplicationController
  
  def update
    @task = Task.find(params[:id])
    @task.update_attributes(permitted_params)
    head :ok
  end
  
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    head :ok
  end
  
  private
  
  def permitted_params
    params.require(:task).permit(:id, :completed, :content)
  end
end
