require 'Nokogiri'
require 'HTTParty'

class Api::V1::BlogController < ApplicationController

  def get_blogs
    page = HTTParty.get("https://medium.com/@#{input_params[:input]}")
    parse_page = Nokogiri::HTML(page)
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
    render json: titles

  end

  private

  def input_params
    params.require(:userInput).permit(:input)
  end



end
