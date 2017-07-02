class Field < ApplicationRecord
  belongs_to :survey
  serialize :value

  TYPES = %w(checkbox select text).freeze

  jsonb_accessor :options,
    values: [array: true, default: []],
    required: [:boolean, default: false]

  validates :name, presence: true
  validates :type, inclusion: { in: TYPES }

  def self.inheritance_column
    'sti_type'
  end

  # query options
  # Field.where("options @> '{\"a\": 1}'")
  # Field.where('options @> ?', { a: 1 }.to_json)
  # Field.where("options->>'a' = ?", "1").explain
end
