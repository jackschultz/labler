class FlagsController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :set_flaggable, only: [:create]
  before_action :set_flag, only: [:update]

  def create
    @flag = @flaggable.flags.find_or_initialize_by(user: current_user)
    @flag.update(flag_params)
    if @flag.save
      flash[:success] = "Flagged Successfully"
      redirect_to @flaggable.next #going to be a document at this point
    else
      flash[:error] = "Error with flagging"
      render @document
    end
  end

  def update
    @flag.update(flag_params)
    @flaggable = @flag.flaggable
    if @flag.save
      flash[:success] = "Flag Updated Successfully"
      redirect_to @flaggable.next #going to be a document at this point
    else
      flash[:error] = "Error with flagging"
      render @document
    end
  end

  private

  def flag_params
    params.require(:flag).permit(:reasoning)
  end

  def set_flaggable
    klass = [Document].detect{|c| params["#{c.name.underscore}_id"]}
    @flaggable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def set_flag
    @flag = current_user.flags.find(params[:id])
  end

end
