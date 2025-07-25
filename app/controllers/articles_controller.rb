class ArticlesController < ApplicationController

  def index
    # Datatable logic for articles
    @pagy, @articles = pagy(Article.all.order(published_at: :desc))
  end
  
  def show
    @article = Article.find(params[:id])
  end

  def search
    query = params[:query]

    if query.present?
      @articles = Article.search_by_all(query).limit(5)
    else
      @articles = []
    end

    # Return a JSON, w/ the most important results
    render json: @articles.select(:id, :title, :author_name)
  end
end