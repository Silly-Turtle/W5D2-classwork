class SubsController < ApplicationController

  before_action :not_moderator, only: [:edit, :update]

  def new
    @sub = Sub.new
    render :new
  end

  def create
    @sub = Sub.new(sub_params)
    @sub.moderator_id = current_user.id

    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      redirect_to new_sub_url
    end
  end

  def index
    @subs = Sub.all
    render :index
  end

  def show
    @sub ||= Sub.find_by(id: params[:id])
    render :show
  end

  def edit
    @sub ||= Sub.find_by(id: params[:id])
    render :edit
  end

  def update
    @sub ||= Sub.find_by(id: params[:id])
    if @sub.update(sub_params)
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :edit
    end
  end

  def sub_params
    params.require(:sub).permit(:title,:description)
  end

  def is_moderator?
    @sub = Sub.find_by(id: params[:id])
    current_user.id == @sub.moderator_id
  end

  def not_moderator
    unless is_moderator?
      flash[:errors] = ['Must be moderator BOO!']
      redirect_to sub_url(@sub)
    end
  end



end
