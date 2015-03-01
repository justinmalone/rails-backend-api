class Api::V1::UsersController < Api::V1::BaseController

  before_filter :authenticate!,  except: [:create,:login, :forgot_password]

  
  # POST /users
  def create

    user = User.create!(params[:user])
    user.user_profile.update_attributes( params[:user_profile])
    user.user_preferences.update_attributes( params[:user_preferences])
    
    respond_to do |format|
        format.json { render json: {user: user.api_base_hash} , status: 201}
    end
  end
  
  # PUT /users/:hashed_id
  def update
    if !params.empty?
      @current_user.update_attributes!(params[:user])
    end
    respond_to do |format|
        format.json { render json: {user: @current_user.api_base_hash}  }
    end
  
  end


  # PUT /login
  # --header "X-AuthToken: 3dc465e370d8"
  # curl -X PUT -d '{"email":"abc@ksdj.com","password":"abc123"}'  --header "X-AuthToken: 79c720d72448"  --header "Accept: application/json" --header "Content-type: application/json"   http://localhost:3000/api/v1/explore.json
  def login

    # TODO: TRACK LOGINS!
    
    response = nil
    status = 200

    user = User.find_by_email(params[:email])
    if user && user.valid_password?(params[:password])
      @current_user = user
      user.rest_api_token
      response = { user: @current_user.api_owner_hash, token: user.api_token }
    else
      response = { error: { message: "User/password not found"}  }
      status = 404
    end

    respond_to do |format|
      format.json { render json: response  , status: status}
    end
  end

  # PUT /forgot
  def forgot_password
    user = User.find_by_email(params[:email])

    if user.nil?
      halt_with_400_bad_request("Email not found")
    else
      user.send_reset_password_instructions unless user.nil?
    end
    
    respond_to do |format|
      format.json { render nothing: true }
    end  

  end

end