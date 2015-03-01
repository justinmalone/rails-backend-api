class Api::V1::BaseController < ApplicationController

  acts_as_token_authentication_handler_for User, fallback_to_devise: false

  skip_before_filter :verify_authenticity_token

  # before_filter { |c| puts request.headers.inspect  }
  
  before_filter :apply_rate_limiting

  rescue_from Exception, with: :error_render_method

  respond_to :json

  def apply_rate_limiting

    # # Set the global per-day rate limit
    # limit = 5000
    # response.headers['X-RateLimit-Limit'] = limit.to_s
    #
    # # Get the current number of hits today
    # hits = REDIS.incr("api_hits_#{Time.zone.today.to_s}_#{request.ip}").to_i
    # remaining = limit - hits + 1
    #
    # if remaining <= 0
    #   response.headers['X-RateLimit-Limit'] = '0'
    #   halt_with_403_forbidden_error('Rate limit exceeded')
    # else
    #   # headers("X-RateLimit-Remaining" => (limit - hits).to_s)
    #   response.headers['X-RateLimit-Limit'] = (limit - hits).to_s
    # end

  end

  def error_render_method( exc )
    puts exc.backtrace
    puts exc.message
    respond_to do |format|
      format.json  { render :json => {error: {message: exc.message } }, :status => 404 }
    end

  end

  protected

  # error handling
  def halt_with_400_bad_request(message = nil)
    message ||= 'Bad request'
    raise message
  end

  # 403 Forbidden error
  def halt_with_403_forbidden_error(message = nil)
    message ||= 'Forbidden'
    raise message
  end

end