class ArticlesController < ApplicationController
  
  before_filter :admin_access_required, :except => [ :index, :show ]

  # GET /articles
  def index
    @articles = Article.list(params)

    if admin?
      render :template => '/articles/admin_index'
    else
      render :action => :index
    end
  end

  # GET /articles/1
  def show
    @article = Article.find(params[:id])
      rescue raise(ActionController::RoutingError, "Sorry, that article doesn't exist.")

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /articles/new
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  def create
    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        format.html { redirect_to(@article, :notice => 'Article was successfully created.') }
      else
        flash.now[:alert] = 'Cannot create the article.'
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /articles/1
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to(@article, :notice => 'Article was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /articles/1
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(articles_url) }
    end
  end
end
