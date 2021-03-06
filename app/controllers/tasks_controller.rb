require 'date'


class TasksController < ApplicationController


  def index
    @tasks = Task.order(:id)
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    Task.find_by(id: params[:id]).destroy
    redirect_to root_path
  end

  def edit
    @task = Task.find(params[:id].to_i)
    unless @task
      redirect_to root_path
    end
  end

  def new
    @task = Task.new
  end

  def show
    @task = Task.find_by(id: params[:id].to_i)
  end

  def update
    task = Task.find_by(id: params[:id].to_i)
    redirect_to tasks_path unless task
    if task.update_attributes task_params
      redirect_to root_path
    else
      render :edit
    end
  end

  def mark_complete
    @today = Date.today

    @task = Task.find (params[:id].to_i)
    @task.status ? @task.update(status: false, completion_date: nil) : @task.update(status: true, initial_status: true, final_status: true, completion_date: @today)
    redirect_to root_path
  end

  def mark_initial_complete
    @task = Task.find (params[:id].to_i)
    @task.initial_status ? @task.update(initial_status: false) : @task.update(initial_status: true)
    redirect_to root_path

  end

  def mark_final_complete
    @task = Task.find (params[:id].to_i)
    @task.final_status ? @task.update(final_status: false) : @task.update(final_status: true)
    redirect_to root_path

  end

  private

  def task_params
    return params.require(:task).permit(:name, :description, :completion_date, :status)
  end

end
