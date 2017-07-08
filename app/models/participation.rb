class Participation < ApplicationRecord
  belongs_to :survey

  validate :validate_answers

  def render
    ApplicationController.render(partial: 'surveys/participation', locals: { participation: self })
  end

  private

  def validate_answers
    survey.fields.each do |field|
      if field.required? && answers[field.name].blank?
        errors.add field.name, 'must not be blank'
      end
    end
  end
end
