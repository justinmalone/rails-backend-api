class Api::V1::BaseController < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  # before_filter { |c| puts request.headers.inspect  }
  
  before_filter :apply_rate_limiting

  rescue_from Exception, with: :error_render_method

  respond_to :json

  def apply_rate_limiting

    # Set the global per-day rate limit
    limit = 5000
    response.headers["X-RateLimit-Limit"] = limit.to_s

    # Get the current number of hits today
    hits = REDIS.incr("api_hits_#{Time.zone.today.to_s}_#{request.ip}").to_i
    remaining = limit - hits + 1

    if remaining <= 0
      response.headers["X-RateLimit-Limit"] = "0"
      halt_with_403_forbidden_error("Rate limit exceeded")
    else
      # headers("X-RateLimit-Remaining" => (limit - hits).to_s)
      response.headers["X-RateLimit-Limit"] = (limit - hits).to_s
    end

  end

  def error_render_method( exc )
    puts exc.backtrace
    puts exc.message
    respond_to do |format|
      format.json  { render :json => {error: {message: exc.message } }, :status => 404 }
    end

  end

  protected

  def auth
    request.headers['X-AuthToken']
  end

  def authenticated?
    request.env['REMOTE_USER']
  end
  
  def authenticate!
    return if authenticated?
    halt_with_401_authorization_required if auth.blank?
    handle_authentication_credentials
  end

  def handle_authentication_credentials
    # good_request = false
    # begin
    #   good_request = !auth.nil? && auth.basic? && auth.credentials
    # rescue
    # end
    # halt_with_400_bad_request unless good_request
    halt_with_401_authorization_required("Bad credentials") unless authenticate(auth)
    request.env['REMOTE_USER'] = auth
  end
  
  def authenticate(token)
    user = User.find_by_api_token(token)
    #puts user.inspect
    if user
      update_location
      @current_user = user
    end
  end

  # Request Validation
  # def require_ssl
  #   unless request.secure? || Rails.env.development? || Rails.env.test?
  #     halt_with_400_bad_request("All API requests must use HTTPS")
  #   end
  # end
  # def validate_format
  #   # head(:not_acceptable) unless request.format.json?
  # end


  # error handling
  def halt_with_400_bad_request(message = nil)
    message ||= "Bad request"
    raise message
  end

  # 403 Forbidden error
  def halt_with_403_forbidden_error(message = nil)
    message ||= "Forbidden"
    raise message
  end
  # 401 Authorization Required
  def halt_with_401_authorization_required(message = nil, realm = "MarketPro")
    message ||= "Authorization required"
    raise message
  end


end