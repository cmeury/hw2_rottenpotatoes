class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  
    if session[:ratings] && !params[:ratings]
      flash.keep
      redirect_to movies_path(params.merge( { ratings: session[:ratings] } ) )
      return
    end

    if session[:sort] && !params[:sort]
      flash.keep
      redirect_to movies_path(params.merge( { sort: session[:sort] } ) )
      return
    end

    sorted_field = params[:sort]
    if sorted_field 
      @movies = Movie.sorted(sorted_field)
      @sort = sorted_field
    else
      @movies = Movie.all
      @sort = nil
    end
    
    if params[:ratings] 
      session[:ratings] = params[:ratings]
    end
    if params[:sort] 
      session[:sort] = params[:sort]
    end
   
    @all_ratings = Movie.unique_ratings
    
    if params[:ratings]
      @sel_ratings = params[:ratings].keys
      @movies = @movies.select { |m| @sel_ratings.include? m.rating } 
    else
      @sel_ratings = @all_ratings.map { |r| r.to_s } 
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
