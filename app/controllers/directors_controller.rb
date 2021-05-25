class DirectorsController < ApplicationController

    def index
        directors = Director.all
        render json: directors
    end
    
    def show
        director = Director.find_by(id: params[:id])
        if director
            render json: director
        else
            render json: { errors: "Director not found" }, status: :not_found
        end
    end

end
