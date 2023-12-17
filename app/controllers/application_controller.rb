class ApplicationController < ActionController::Base
  rescue_from ::ActiveRecord::RecordInvalid, ::ActiveRecord::RecordNotSaved, with: :record_not_saved

  def record_not_saved(exception)
    render json: { message: exception.message, success: false }, status: :unprocessable_entity
  end

end
