class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper

  before_filter :instance_setup



  def instance_setup

    @base_user = request.subdomain.split(".")[0]
    @user = User.find( @base_user )

    if @user.publisher.nil?
      throw :halt, [404, "Not found"]
    end
    @publisher = @user.publisher

    @lat = request.cookies["lat"].to_f
    @lng = request.cookies["lng"].to_f
  end

end
