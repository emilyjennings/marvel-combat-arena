class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def desc_split(char)
    char[0]['description'].split(' ')
  end

  def comic_split(char)
    char[0]['comics']['items'][0]['name'].split(' ')
  end

  def desc_blank?(char)
    char[0]['description'].blank?
  end

  def first_comic_blank?(char)
    char[0]['comics']['items'][0].nil?
  end
end
