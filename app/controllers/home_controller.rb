class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @tasks = current_user.tasks.order_by_custom_criteria
  end
end
