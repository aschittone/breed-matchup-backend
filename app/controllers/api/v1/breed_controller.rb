class Api::V1::BreedController < ApplicationController

  def get_dogs
    dog_traits = {
      engergy: ["feisty", "energy", "alert", "lively", "sociable", "cheerful", "happy"],
      focus: ["intelligent", "loyal", "alert", "vigilant", "devoted", "smart", "intelligent", "alert"],
      confidence: ["fearless", "affectionate", "confident", "friendly", "outgoing", "sociable"],
      independence: ["elegent", "bold", "spunky", "independent", "calm"]
    }

    personalities = dog_params
    byebug
  end

  private

  # def dog_params
  #   params.require(:personInfo).permit(:info => {:energy, :focus, :confidence, :independence})
  # end

end
