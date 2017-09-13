# require 'HTTParty'

class Api::V1::BreedController < ApplicationController

  def get_dogs
    best_trait = convert_objects(dog_params)[0]
    dog_traits_array = choose_dog_traits(best_trait).flatten
    chosen_dogs = match_dogs(dog_traits_array)
    info_and_pics = get_pictures(chosen_dogs)
    render json: info_and_pics
  end

  def get_pictures(top_three)
    info_and_images = []
    top_three.each do |dog|
      name = ''
      array = dog.name.to_s.split(' ').reverse
        array.each do |word|
          name += word + '/'
        end
      response = Excon.get("https://dog.ceo/api/breed/#{name}images/random")
      if response.body.include?("404") || response.body.include?("Not found")
        page = HTTParty.get("https://www.google.com/search?hl=en&tbm=isch&source=hp&biw=1276&bih=636&q=#{dog.name}&oq=#{dog.name}&gs_l=img.3...476.602.0.705.4.4.0.0.0.0.0.0..0.0....0...1.1.64.img..4.0.0.0.ApwfLhUikNo")
        parse_page = Nokogiri::HTML(page)
        info_and_images.push([dog.name.to_s, dog.description, parse_page.css('.images_table img')[0].attr('src')])
      else
        info_and_images.push([dog.name.to_s, dog.description, JSON.parse(response.body)["message"]])
      end
    end
    info_and_images
  end


  def match_dogs(dog_traits_array)
    matched_dogs = []
    all_dogs = Breed.all
    all_dogs.each do |breed|
      count = 0
      dog_traits_array.each do |trait|
        if breed.description.downcase.include?(trait)
          count += 1
          if count >= 2
            matched_dogs << breed
          end
        end
      end
    end
    matched_dogs.sample(3)
  end

  def choose_dog_traits(best_trait)
    traits_array = []
    dog_traits.each do |key, value|
      if best_trait == key.to_s
        traits_array.push(value)
      end
    end
    traits_array
  end


  def dog_traits
    dog_traits = {
      energy: ["feisty", "energy", "alert", "lively", "sociable", "cheerful", "happy", "hunt", "hunter", "athletic"],
      focus: ["trainable", "intelligent", "loyal", "alert", "vigilant", "devoted", "smart", "intelligent", "alert", "sweet"],
      confidence: ["gentle", "elegent", "patient", "affectionate", "confident", "friendly", "outgoing", "sociable", "loving", "proud"],
      independence: ["curious", "fearless", "elegent", "bold", "spunky", "independent", "calm", "dignified"]
    }
  end

  def convert_objects(params)
    newParams = []
    params[:info].map do |trait|
      newParams << trait.to_h.to_a.flatten
    end
    top_trait(newParams)
  end


  def top_trait(traits_array)
    first_trait = traits_array[0]
    traits_array.each_with_index do |trait, i|
      if trait[1] > first_trait[1]
        first_trait = trait
      end
    end
    return first_trait
  end



  private

  def dog_params
    params.require(:personInfo).permit(info: [:energy, :focus, :confidence, :independence])
  end

end
