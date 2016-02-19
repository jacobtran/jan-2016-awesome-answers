class SubscribeController < ApplicationController
  def index
    # This renders the app/views/welcome/about.html.erb template
    # with no layout
    # render "/welcome/about", layout: false
  end

  def create
    render text: params
  end
end
