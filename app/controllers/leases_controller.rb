class LeasesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :new]


def index
  @leases = Lease.all
  @hash = Gmaps4rails.build_markers(@leases) do |lease, marker|
    marker.lat lease.latitude
    marker.lng lease.longitude
  end
end

  def new
    @lease = Lease.new
  end

  def create
    @lease = Lease.new(lease_params)
    if @lease.save
      redirect_to @lease
    else
      render 'new'
    end
  end

  def show
    @lease = Lease.find(params[:id])
    @reviews = Review.where(lease_id: @lease)
    @hash = Gmaps4rails.build_markers(@lease) do |lease, marker|
      marker.lat lease.latitude
      marker.lng lease.longitude
    end
  end

  def search
    if params[:search].present?
      @leases = Lease.search(params[:search])
    else
      @leases = Lease.all
    end
  end

  def update
    @lease = Lease.find(params[:id])
    if @lease.update_attributes(lease_params)
     flash[:success] = "Images updated"
     redirect_to @lease
    else
     render 'show'
   end
  end

private

  def lease_params
    params.require(:lease).permit(:address, :province, :city, :university, :postalcode, :numberofbedrooms,
                  :numberofparkingspots, :numberofbathrooms, :utilities, :internet, :image)
  end
end
