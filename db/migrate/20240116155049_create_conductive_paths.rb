class CreateConductivePaths < ActiveRecord::Migration[7.1]
  def change
    create_table :conductive_paths do |t|
      t.json :positions
      t.integer :evaluation_id

      t.timestamps
    end
    add_index :conductive_paths, :evaluation_id
  end
end
