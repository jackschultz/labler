class HomeController < ApplicationController
  protect_from_forgery with: :exception

  def index
    render layout: false
  end

end
