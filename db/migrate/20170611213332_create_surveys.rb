class CreateSurveys < ActiveRecord::Migration[5.1]
  def change
    create_table :surveys do |t|
      t.string :token
      t.string :name
      t.text :description

      t.timestamps
    end
    add_index :surveys, :token, unique: true
  end
end
