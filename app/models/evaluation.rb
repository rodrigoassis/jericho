class Evaluation < ApplicationRecord
  validates :grid, presence: true
  validate :grid_format

  def grid_format
    return unless grid.present?

    errors.add(:grid, 'must be made of 0s and 1s') unless (grid.split('') - ['1'] - ['0'] - ["\r"] - ["\n"]).blank?

    rows = grid.split("\r\n")
    errors.add(:grid, 'must be NxN') if rows.any? { |row| row.size != rows.size }
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "grid", "id", "id_value", "result", "updated_at"]
  end
end
