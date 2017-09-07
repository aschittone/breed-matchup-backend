require 'json'
require 'excon'

class Api::V1::PersonalityController < ApplicationController


  def get_traits
    content = "sample text"
   response = Excon.post("https://gateway.watsonplatform.net/personality-insights/api/v2/profile",
     :body => content,
     :headers => { "Content-Type" => "text/plain" },
     :user => "7d414c9d-43d1-446a-8fe8-abc0189bee45",
     :password => "3XlCsgoqR16O"
   )
   profile = JSON.load(response.body)
   render json: profile
  end

end
