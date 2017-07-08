class ParticipationsController < ApplicationController
  def create
    @survey = Survey.find(params.dig(:participation, :survey_id))
    @participation = Participation.new(participation_params)
    if @participation.save
      ActionCable.server.broadcast 'participation_channel', action: 'create', id: @participation.id, content: @participation.render
      @participation = Participation.new(survey: @survey)
    end
  end

  def destroy
    @participation = Participation.find(params[:id])
    if @participation.destroy
      ActionCable.server.broadcast 'participation_channel', action: 'destroy', id: @participation.id
    end
  end

  private

  def participation_params
    params.require(:participation).permit(:survey_id, answers: {})
  end
end
