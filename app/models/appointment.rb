class Appointment < ApplicationRecord
  validates :name, :date, presence: true
  validate :is_date_past?, if: :date

  private

  def is_date_past?
    return unless date  < current_date
    errors.add(:end_date, "must be greater than current time ⚠️ ")
  end

  def current_date
    Time.now
  end
end
