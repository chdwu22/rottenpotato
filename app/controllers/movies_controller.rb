class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
##################################################################
  def index
    if(params[:commit]=='Refresh')
      session[:ratings] = params[:ratings] || {}
    end
    
    @all_ratings= Movie.get_ratings
    @selected_ratings = session[:ratings]
    @order  = params[:sort_by] || :id
    
    if @selected_ratings.empty? == false
      @movies = Movie.where(:rating => @selected_ratings.keys).order(@order)
    else
      @movies = Movie.all.order(@order)
      @selected_ratings=@all_ratings
    end
    
    instance_variable_set("@#{params[:sort_by]}_active", "hilite")
  end

#################################################################
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
