class FavouritesController < ApplicationController
  before_action :authenticate_user

  def index
    @questions = current_user.favourite_questions
  end

  def create
    q = Question.find params[:question_id]
    fav = Favourite.new(question: q, user: current_user)
    if fav.save
      redirect_to q, notice: "Added Favourite"
    else
      redirect_to q, alert: "Can't Add Favourite"
    end
  end

  def destroy
    question = Question.find params[:question_id]
    favourite = current_user.favourites.find params[:id]
    favourite.destroy
    redirect_to question_path(question), notice: "Question deleted from favourites"
  end
end
