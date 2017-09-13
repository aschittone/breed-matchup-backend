require 'Nokogiri'
require 'HTTParty'

class Api::V1::BlogController < ApplicationController

  def get_blogs
    page = HTTParty.get("https://medium.com/@#{input_params[:input]}")
    parse_page = Nokogiri::HTML(page)
    # byebug
    titles = []
    counter = 0
    parse_page.css('.graf--title').css('h3').each do |title|
      counter += 1
      titles << {title.children.text => []}
      parse_page.css('.postArticle').css('a.link.link--darken').each do |link|
        if link["href"][link["href"].length - 17] == counter.to_s
          titles[counter - 1][title.children.text] << link["href"]
        end
      end
    end
    noko_objects = parse_page.css('.graf.graf--p')
    if noko_objects.length > 1
      result = get_first_sentence(titles, noko_objects)
      render json: result
    else
      render json: titles
    end
    # byebug

  end

  def get_first_sentence(array, noko_objects)
    new_objects = noko_objects[0..2]
    # byebug
    new_array = []
    counter = -1
    new_objects.each_with_index do |sentence, index|
      counter += 1
      # byebug
      array[index].each do |key, value|
        new_array << {key => value}
        if counter == index
          new_array[index][key] << sentence.text
        end
      end
    end
    new_array
  end

  private

  def input_params
    params.require(:userInput).permit(:input)
  end



end
