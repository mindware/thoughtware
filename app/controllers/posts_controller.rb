
class PostsController < ApplicationController

  def testy
	puts "test"
  end

  # GET /posts
  # GET /posts.json

  def index
    @posts = Post.all(:order => "id DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
      if (@post.views == nil)
          @post.views = 0
      end
          @post.views = @post.views + 1
      @post.save
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])
    ### Setup Post ###
    # Save the user_id as the owner
    @post.user_id = current_user.id if !current_user.nil?
    @post.status  = 1
    # @post.thumbnail_code  = 
    # @post.auto_embed      = 
    # @post.manual_embed    =
    # @post.comments_count  = 
    # @post.thumbnail_code  = 
    # @post.comments_last_author  = 
    # @post.views            = 
    # @post.last_viewed_date = 
    # @post.link_directly    = 
    # @post.views = {}

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    # We should add an editor id here, or a history of editors and contributors
    @post = Post.find(params[:id])        
    respond_to do |format|
      if @post.url_changed? 
          @post.thumbnail_url = nil # delete the thumbnail
      end

      if @post.update_attributes(params[:post])        
        # After each update, we have to run a series of processes for the post:
        @post.setup # sets up post, and adds delayed jobs (queues delayed job tasks)
        @post.save  # here we force a save for the updated attributes called upon by setup

        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  # Endless scrolling 
  def more
      params[:page] = 1 if params[:page].nil?
      @post = Post.find(:all, :conditions => {:offset => params[:page] * 10, :limit => 10})
  end

end
