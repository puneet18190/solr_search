class PeopleController < ApplicationController
  def index
      @people = []
      if params[:search].present?# || params[:radius].present?
        params[:search].split.each do |obj|
          @people << Person.where("name LIKE ? OR about LIKE ?", "#{obj}", "#{obj}")
        end
        @people << Person.where("bed = ?" ,"#{params[:search].humanize.split(' bed')[0].last.to_i}" ) if params[:search].humanize.split(' bed')[0].last.to_i != 0
        # params[:search].split.each do |obj|
        #   search = Person.search do 
        #     # without(:id, current_user.id)
        #     fulltext obj  #params[:search] 
        #     # with :bed, obj if obj.to_i != 0
        #     # if current_user.has_location? 
        #     #   with(:location).in_radius(current_user.lat, current_user.lon, params[:radius])
        #     # end
        #     # without(:dislikes, params[:search]) if params[:search].present?
        #   end
        #   @people << search.results
        # end
        # binding.pry
        @people = @people.flatten.uniq
      else
        @people = []
      end

  end

  def create
    @new_person = Person.new(person_params)
    if @new_person.save
      session[:current_user_id] = @new_person.id
      redirect_to people_path
    else
      flash.now.alert = 'Please fill your profile'
      render :index
    end
  end

  private

  def person_params
    params.require(:person).permit(:name, :about, :likes, :dislikes, :lat, :lon)
  end
end
