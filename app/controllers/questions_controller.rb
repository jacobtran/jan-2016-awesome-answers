class QuestionsController < ApplicationController
  # this `before_action` will call the `find_question` method before executing
  # any other action.
  # we can specify :only or :except to be more speicfic about the actions
  # which the before_action apply to
  # before_action :find_question, except: [:new, :create, :index]
  before_action :find_question, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_user, except: [:index, :show]

  before_action :authorize_user, only: [:edit, :update, :destroy]

  def new
    @question = Question.new
  end

  def create
    # params => {"question"=>{"title"=>"hello world", "body"=>"something here"}}
    # question       = Question.new
    # question.title = params[:question][:title]
    # question.body  = params[:question][:body]

    @question      = Question.new question_params
    @question.user = current_user
    if @question.save
      # all these formats are possible ways to redirect in Rails:
      # redirect_to question_path({id: @question.id})
      # redirect_to question_path({id: @question})
      # redirect_to @question
      flash[:notice] = "Question Created Successfully!"
      redirect_to question_path(@question)
    else
      # This will render app/views/questions/new.html.erb template
      # we need to be explicit about rendering the new template becuase the
      # default behaviour is to render `create.html.erb`
      # you can specify full path such as: render "/questions/new"
      flash[:alert] = "Question wasn't created. Check errors below"
      render :new
    end
  end

  # GET: /questions/13
  def show
    @question.view_count += 1
    @question.save
    @answer = Answer.new
  end

  def index
    @questions = Question.all
  end

  def edit
  end

  def update
    # We call the update with sanitized params
    if @question.update question_params
      # we redirect to the question show page
      redirect_to(question_path(@question), {notice: "Question updated!"})
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    # we redirect to the index page
    redirect_to questions_path, notice: "Question deleted!"
  end

  private

  def question_params
    # using params. require ensures that there is a key called `question` in my
    # params. the `permit` method will only allow paramsters that you explicitly
    # list, in this case: title and body
    # this is called Strong Paramters
    params.require(:question).permit([:title, :body, :category_id])
  end

  def find_question
    @question = Question.find params[:id]
  end

  def authorize_user
    unless can? :manage, @question
      redirect_to root_path, alert: "access denied!"
    end
  end

end
