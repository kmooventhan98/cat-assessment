require 'faraday'
require 'slack-notifier'

class AppointmentsController < ApplicationController
  before_action :verify_params, only: %i[create update]

  def create
    @appointment = Appointment.new(appointment_params)
    if @appointment.save
      notify_webhooks
      render json: @appointment, status: :created
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    raise Error, e.message
  end

  def update
    if appointment.update!(appointment_params)
      notify_webhooks
      render json: appointment, status: :ok
    else
      render json: appointment.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    raise Error, e.message
  end

  private

  def appointment
    @appointment ||= Appointment.find(params[:id])
  end

  def appointment_params
    params.permit(:name, :date)
  end

  def verify_params
    render json: {error: I18n.t('invalid_params') } unless params.present?
  end

  
  def notify_webhooks
    payload = {
      id: @appointment.id,
      name: @appointment.name,
      date: @appointment.date
    }
    SlackWebhook.new(payload: payload).notify
  end

end
