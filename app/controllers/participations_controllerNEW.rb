class ParticipationsController < ApplicationController
  def create
    @survey = Survey.find(params.dig(:participation, :survey_id))
    @participation = Participation.new(participation_params)

    if @participation.save
      render json: { token: @survey.token, id: @participation.id }, status: :ok
      ActionCable.server.broadcast 'participation_channel', action: 'create', id: @participation.id, content: @participation.render
    else
      render json: @participation.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @participation = Participation.find(params[:id])
    if @participation.destroy
      render json: { token: @participation.survey.token }, status: :ok
      ActionCable.server.broadcast 'participation_channel', action: 'destroy', id: @participation.id
    end
  end

  private

  def participation_params
    params.require(:participation).permit(:survey_id, answers: {})
  end
end
