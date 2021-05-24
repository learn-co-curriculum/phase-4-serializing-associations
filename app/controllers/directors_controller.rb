class DirectorsController < ApplicationController

    def show
        director = Director.find_by(id: params[:id])
        if director
            render json: director
        else
            render json: { errors: "Director not found" }, status: :not_found
        end
    end

    def index
        directors = Director.all
        render json: directors
    end
end
