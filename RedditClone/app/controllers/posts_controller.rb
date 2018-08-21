class PostsController < ApplicationController
  before_action :not_author?, only: [:edit, :update]
  def new
    @sub_id = params[:id]
    @subs = Sub.all
    @post = Post.new
    render :new
  end

  def create
    @post = Post.new(post_params)
    @post.author_id = current_user.id
    if @post.save
      redirect_to post_url(@post)
    else
      flash[:errors] = @post.errors.full_messages
      redirect_to new_post_url
    end
  end

  def edit
    @subs = Sub.all
    @post = Post.find_by(id: params[:id])
    render :edit
  end

  def update
    @post ||= Post.find_by(id: params[:id])
    if @post.update(post_params)
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :edit
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
    render :show
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @sub = @post.sub
    @post.destroy
    redirect_to sub_url(@sub)
  end

  def post_params
    params.require(:post).permit(:title,:url,:content, :sub_id)
  end

  def is_author?
    @post = Post.find_by(id: params[:id])
    current_user.id == @post.author_id
  end

  def not_author
    unless is_author?
      flash[:errors] = ['Must be author MUAHAHAHAHA']
      redirect_to post_url(@post)
    end
  end

end
