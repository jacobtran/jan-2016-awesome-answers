class AnswersController < ApplicationController
  before_action :authenticate_user

  def create
    @question = Question.find params[:question_id]
    answer_params = params.require(:answer).permit(:body)
    @answer   = Answer.new answer_params
    @answer.question = @question
    @answer.user     = current_user
    if @answer.save
      redirect_to question_path(@question), notice: "Answer created!"
    else
      render "/questions/show"
    end
  end

  def destroy
    # question = Question.find params[:question_id]
    # answer   = question.find params[:id]
    answer = Answer.find params[:id]
    redirect_to root_path, alert: "Access denied" unless can? :manage, answer
    answer.destroy
    redirect_to question_path(params[:question_id]), notice: "Answer deleted!"
  end

end
