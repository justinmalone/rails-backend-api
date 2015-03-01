class Api::V1::SessionsController < Devise::SessionsController
  prepend_before_filter :require_no_authentication, :only => [:create]
  skip_before_filter :verify_signed_out_user
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  acts_as_token_authentication_handler_for User, :except => :create, fallback_to_devise: false

  include Devise::Controllers::Helpers

  respond_to :json

  def create
    resource = User.find_for_database_authentication(:email => params[:user][:email])
    return failure unless resource

    if resource.valid_password?(params[:user][:password])
      sign_in(:user, resource)
      render :json=> {:success => true, :token => resource.authentication_token}
      return
    end
    failure
  end

  def destroy
    current_user.authentication_token = nil
    current_user.save!
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)

    render :status => 200, :json => {}
  end

  def failure
    return render json: { success: false, errors: [t('api.v1.sessions.invalid_login')] }, :status => :unauthorized
  end

end