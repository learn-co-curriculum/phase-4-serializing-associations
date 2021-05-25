class MoviesController < ApplicationController

  def index
    movies = Movie.all
    render json: movies
  end

  def show
    movie = Movie.find_by(id: params[:id])
    if movie
      render json: movie
    else
      render json: { error: "Movie not found" }, status: :not_found
    end
  end

  def summary
    movie = Movie.find_by(id: params[:id])
    if movie
      render json: movie, serializer: MovieSummarySerializer
    else
      render json: { error: "Movie not found" }, status: :not_found
    end
  end

  def summaries
    movies = Movie.all
    render json: movies, each_serializer: MovieSummarySerializer
  end
end