class LikesController < ApplicationController
  before_action :authenticate_user

  def create
    q = Question.find params[:question_id]
    like = Like.new(question: q, user: current_user)
    if like.save
      redirect_to q, notice: "Liked!"
    else
      redirect_to q, alert: "Not Liked!"
    end
  end

  def destroy
    like = current_user.likes.find params[:id]
    q    = Question.find params[:question_id]
    like.destroy
    redirect_to question_path(q), notice: "Un-liked!"
  end
end
