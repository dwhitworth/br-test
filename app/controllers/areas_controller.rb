class AreasController < ApplicationController

  # before_filter :verify_admin, :only => [:new, :edit, :create, :destroy]


  def index
    @areas = Area.all

    respond_to do |format|
      format.html
      format.json { render json: @areas }  # respond with the created JSON object
    end
  end

  def show
    @area = Area.friendly.find(params[:id])
    @hero_video = @area.videos.find_by(priority: 1)
    @hero_photo = @area.photos.find_by(priority: 1)
    @photos = @area.photos.where.not(priority: 1)
    @request_xhr = request.xhr?

    respond_to do |format|
      format.html { render 'show', :layout => !request.xhr? }
      format.json { render json: @area}
    end

  end

  def create
    @area = Area.new(area_params)

    if @area.save
      redirect_to(areas_path, notice: 'Area succesfully saved')
    else
      redirect_to '/areas#new', notice: 'Area not saved!'
    end
  end

  def new
    @area = Area.new
    @area.photos.build
  end

  def edit

    @area = Area.friendly.find(params[:id])
    @photos = @area.photos
    @photo = Photo.new

  end


  def update

    @area = Area.friendly.find(params[:id])

    if @area.update(area_update_params)
      redirect_to :back
    end

  end

  def destroy

  end

  def mapdata
    @areas = Area.all

    # geojson for MapBox map
    @geojson = Area.all_geojson

    respond_to do |format|
      format.html
      format.json { render json: @geojson }  # respond with the created JSON object
    end
  end

  def import
    Area.import(params[:file])
    redirect_to areas_path, notice: "Areas imported."
  end

  def default_serializer_options
    {root: false}
  end

  private
    def area_params
      params.require(:area).permit(:code, :identifier, :display_name, :country, :short_intro, :description, :latitude, :longitude, :address, :published_status, photos_attributes: [:area_id, :title, :path, :caption, :credit, :caption_source, :priority])
    end

    def area_update_params
      params.require(:area).permit(:display_name, :short_intro, :description, :address, :published_status, photo: [:title, :path, :credit, :caption, :area_id, :caption_source, :priority])
    end

end
