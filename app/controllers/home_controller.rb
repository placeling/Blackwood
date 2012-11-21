class HomeController < ApplicationController


  def index
    respond_to do |format|
      format.html
    end
  end

  def list

    @perspectives = get_perspectives(@user, params[:category])

    if @lat && @lng
      @perspectives.each do |perspective|
        #add distance to in meters
        perspective.distance = Geocoder::Calculations.distance_between([@lat, @lng], [perspective.place.location[0], perspective.place.location[1]], :units => :km)
      end
      @perspectives = @perspectives.sort_by { |perspective| perspective.distance }
    end

    respond_to do |format|
      format.html
    end
  end

  def map

    if @lat && @lng
      @display_lat = @lat
      @display_lng = @lng
    else
      @display_lat = @user.loc[0]
      @display_lng = @user.loc[1]
    end

    respond_to do |format|
      format.html
    end
  end

  def place
    @perspective = Perspective.for_user_and_place( @base_user, params[:id] )

    respond_to do |format|
      format.html
    end
  end

  def mapdata
    @perspectives = get_perspectives(@user, params[:category])

    respond_to do |format|
      format.json{ render :json => {:perspectives => @perspectives } }
    end

  end


end
