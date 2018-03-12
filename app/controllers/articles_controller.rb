class ArticlesController < ApplicationController

    before_action :authenticate_user!, {only: [:new, :edit, :update, :destroy]}

    def index
        @articles = Article.all
        @ids = REDIS.zrevrange "articles/pv", 0, 2
        @timeSessions = REDIS.zrevrange "articles/time", 0, -1
    end

    def show
        @article = Article.find_by(id: params[:id])
        REDIS.zincrby "articles/pv", 1, "#{@article.id}"
        @ids = REDIS.zrevrange "articles/pv", 0, 2
        REDIS.zadd "articles/time", DateTime.now.to_i, "#{@article.id}"
    end

    def new
        @article = Article.new
    end

    def create
        @article = Article.new(
            title: params[:title],
            body: params[:body],
            create_user: current_user.email
        )
        @article.save
        REDIS.zadd "articles/pv", 0, @article.id
        REDIS.zadd "articles/time", DateTime.now.to_i, "#{@article.id}"
        redirect_to("/")
    end

    def edit
        @article = Article.find_by(id: params[:id])
    end

    def update
        @article = Article.find_by(id: params[:id])
        @article.title = params[:title]
        @article.body = params[:body]
        @article.save
        redirect_to("/articles/#{@article.id}")
    end

    def destroy
        @article = Article.find_by(id: params[:id])
        REDIS.zrem "articles/pv", @article.id
        REDIS.zrem "articles/time", @article.id
        @article.destroy
        redirect_to("/")
      end

end
