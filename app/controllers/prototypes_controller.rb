class PrototypesController < ApplicationController
  #ログイン状態の投稿者のみ編集/削除のアクションを許可する
  before_action :authenticate_user!, except: [:index, :show]
  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end
  
  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      #保存に失敗すると新規投稿ページに戻る
      render :new
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = Comment.all
  end

  def edit
    @prototype = Prototype.find(params[:id])
    unless user_signed_in? && current_user.id == @prototype.user_id
      redirect_to root_path
    end
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype)
    else
      render :edit
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
    redirect_to root_path
  end

  private
  def prototype_params
    #許可するカラムにimageを付け加え忘れずに
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end
end
