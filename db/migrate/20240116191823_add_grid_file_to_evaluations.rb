class AddGridFileToEvaluations < ActiveRecord::Migration[7.1]
  def change
    add_column :evaluations, :grid_file, :string
  end
end
