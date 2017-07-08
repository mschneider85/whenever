class Survey < ApplicationRecord
  has_many :fields, dependent: :destroy
  has_many :participations

  accepts_nested_attributes_for :fields, allow_destroy: true

  # regenerate token with `survey.regenerate_token`
  has_secure_token

  validates :name, presence: true

  def to_param
    token
  end
end
