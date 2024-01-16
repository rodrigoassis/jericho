class ConductivePath < ApplicationRecord
  belongs_to :evaluation

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "evaluation_id", "id", "id_value", "positions", "updated_at"]
  end
end
