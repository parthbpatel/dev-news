class LinksController < ApplicationController
  LINKS_PER_PAGE = 8
  COMMENTS_PER_PAGE = 5

  before_action :require_login, except: %i[index show newest]
  before_action :set_link, only: %i[show upvote downvote]
  before_action :set_owned_link, only: %i[edit update destroy]

  def index
    @pagy, @links = pagy_countless(Link.for_feed.hottest, items: LINKS_PER_PAGE)
    render_links_page if infinite_scroll_request?
  end

  def show
    @comment = Comment.new
    @pagy, @comments = pagy_countless(@link.comments.for_display, items: COMMENTS_PER_PAGE)
    render_comments_page if infinite_scroll_request?
  end

  def new
    @link = current_user.links.new
  end

  def create
    @link = current_user.links.new(link_params)

    if @link.save
      redirect_to @link, notice: 'Link successfully created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @link.update(link_params)
      redirect_to @link, notice: 'Link successfully updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @link.destroy
    redirect_to root_path, notice: 'Link successfully deleted', status: :see_other
  end

  def upvote
    apply_vote(Vote::UP)
  end

  def downvote
    apply_vote(Vote::DOWN)
  end

  def newest
    @pagy, @links = pagy_countless(Link.for_feed.newest, items: LINKS_PER_PAGE)
    render_links_page if infinite_scroll_request?
  end

  private

  def link_params
    params.require(:link).permit(:title, :url, :description)
  end

  def set_link
    @link = Link.for_show.find(params[:id])
  end

  def set_owned_link
    @link = current_user.links.find(params[:id])
  end

  def apply_vote(value)
    Votes::Toggle.call(user: current_user, link: @link, value: value)
    redirect_back fallback_location: @link, notice: 'Vote updated', status: :see_other
  end

  def infinite_scroll_request?
    request.xhr?
  end

  def render_links_page
    render partial: 'links/page', locals: { links: @links, pagy: @pagy }
  end

  def render_comments_page
    render partial: 'comments/page', locals: { comments: @comments, pagy: @pagy }
  end
end
