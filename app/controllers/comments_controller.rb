class CommentsController < ApplicationController
  COMMENTS_PER_PAGE = 5

  before_action :require_login, except: :index
  before_action :set_link, only: %i[create edit update destroy]
  before_action :set_comment, only: %i[edit update destroy]
  before_action :authorize_comment!, only: %i[edit update destroy]

  def index
    @pagy, @comments = pagy_countless(Comment.includes(:user, :link).recent, items: COMMENTS_PER_PAGE)
    render partial: 'comments/page', locals: { comments: @comments, pagy: @pagy } if request.xhr?
  end

  def create
    @comment = current_user.comments.new(link: @link)
    @comment.assign_attributes(comment_params)

    if @comment.save
      redirect_to @link, notice: 'Comment created'
    else
      @pagy, @comments = pagy_countless(@link.comments.for_display, items: COMMENTS_PER_PAGE)
      render 'links/show', status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to @link, notice: 'Comment updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to @link, notice: 'Comment deleted', status: :see_other
  end

  private

  def set_link
    @link = Link.find(params[:link_id])
  end

  def set_comment
    @comment = @link.comments.find(params[:id])
  end

  def authorize_comment!
    return if current_user.owns_comment?(@comment)

    redirect_to @link, notice: 'Not authorized to manage this comment', status: :see_other
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
