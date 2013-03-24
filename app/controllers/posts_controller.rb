class PostsController < ApplicationController
  before_filter :get_tags, :recent_posts
  before_filter :authenticate_admin!, :except => [:index, :show]
  

  # GET /posts
  # GET /posts.json
  def index    
    
    if admin_signed_in?
      if params[:tag]
        @posts = Post.tagged_with(params[:tag]).page(params[:page]).per(10) 
      else
        @posts = Post.page(params[:page]).per(10) 
      end
    else
      @search = Post.search do
          fulltext params[:search]
          paginate :page => params[:page], :per_page => 10
      end

      if params[:tag]
        @posts = Post.published.tagged_with(params[:tag]).page(params[:page]).per(10)  
      else 
       # @posts = Post.order(:updated_at).page(params[:page]).per(10)  
         @posts = @search.results
      end 
    end

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
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
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

  def publish
    @post = Post.find(params[:id])
    @post.published = true
    @post.save  
    redirect_to posts_url
  end

  def unpublish
    @post = Post.find(params[:id])
    @post.published = false
    @post.save  
    redirect_to posts_url
  end

  private
  def get_tags
    @tags = Post.tag_counts_on(:tags)
  end
  
  def recent_posts
    @recent_posts = Post.published.order("created_at desc").take(5)
  end
end
