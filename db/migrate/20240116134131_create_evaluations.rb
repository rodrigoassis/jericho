class CreateEvaluations < ActiveRecord::Migration[7.1]
  def change
    create_table :evaluations do |t|
      t.text :grid
      t.boolean :result, default: false

      t.timestamps
    end
    add_index :evaluations, :result
  end
end
