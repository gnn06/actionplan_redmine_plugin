class PlanController < ApplicationController

  before_action :find_issue, :only => [:show]

  helper :issues

  def index
  end

  def show
    #byebug
  end
end
