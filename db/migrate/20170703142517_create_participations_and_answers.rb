class CreateParticipationsAndAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :participations do |t|
      t.belongs_to :survey, index: true
      t.jsonb :answers, null: false, default: {}

      t.timestamps
    end
  end
end
