class AppliesController < ApplicationController
  before_action :job_seeker_has_access

  #-------------JobSeeker_can_show_all_own_apply---------
  def index
    seeker_apply=@current_user.applies.all
    render json: seeker_apply
  end

  #-----------------JobSeeker_can_apply--------------------
  def create
    apply = @current_user.applies.new(apply_params)
    if apply
      apply.status = 'Pending..'

      if apply.save
        render json: apply, status: :ok
      else
        render json: { error: apply.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Id not found' }, status: :not_found
    end
  end

  #------------------JobSeeker_can_delete_own_apply---------------
  def destroy
    apply = @current_user.applies.find(params[:id])
    if apply.destroy
      render json: { message: 'Apply deleted...'}
    else
      render json: { errors: apply.errors.full_messages }, status: :unprocessable_entity
    end
  end

  #---------------JobSeeker_can_see_pericular_apply--------------
  def show
    apply = @current_user.applies.find(params[:id])
    if apply.present?
      render json: apply
    else
      render json: "Apply not found", status: :not_found
    end
  end

  private
  def apply_params
    params.permit(:job_id,:resume)
  end
end
