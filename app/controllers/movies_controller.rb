class MoviesController < ApplicationController
	#layout "default"
	def index
		#@movies="Welcome to movies page"
		@movie = Movie.all
		puts @movie
		render 'index'

	end
	def new
		#@new="Yo NEW!"
		render 'new'
	end
	def create
		@movie = Movie.new(movie_params)
		if @movie.save
			render 'index'
		else
			render 'new'
		end
	end
	def edit
		@movie = Movie.find(params[:id])
		#render 'edit'
	end
	def update
		@movie = Movie.find(params[:id])
		@movie = @movie.update_attributes(movie_params)
		flash[:notice] = "Movie record updated successfully!!"
		redirect_to :action => 'index'
		#render 'index'

	end

	private
		def movie_params
			params.require(:movie).permit(:title, :genre, :release_date)
		end
end
