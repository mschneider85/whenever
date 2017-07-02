class CreateFields < ActiveRecord::Migration[5.1]
  def change
    create_table :fields do |t|
      t.string :name
      t.string :type, null: false, default: 'text', index: true
      t.jsonb :options, null: false, default: {}
      t.belongs_to :survey, foreign_key: true, index: true

      t.timestamps

      t.index :options, using: :gin
    end
  end
end
