class PagesController < ApplicationController
  def index
  end
  
  def test
    @q = Element.search(params[:q])
    @elements = @q.result
  end
end
