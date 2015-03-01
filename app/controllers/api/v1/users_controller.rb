class Api::V1::UsersController < Api::V1::BaseController

  # GET /user
  def show
    respond_to do |format|
      format.json { render json: {user: current_user}  }
    end
  end

  # PUT /user
  def update
    # user registrations controller to update email/password
    # unless params.empty?
    #   current_user.update_attributes!(user_params)
    # end
    respond_to do |format|
        format.json { render json: {user: current_user}  }
    end
  
  end

  # def user_params
  #   params.require(:user).permit(:email, :password)
  # end

end