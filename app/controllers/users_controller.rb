class UsersController < ApplicationController

  get '/signup' do
    if is_logged_in?(session)
      redirect '/tweets'
    else
      erb :'/users/create_user'
    end
  end

  post '/signup' do
    if params[:username].empty? || params[:email].empty? || params[:password].empty?
      redirect '/signup'
    else
      user = User.create(username: params[:username], email: params[:email], password: params[:password])
      session[:user_id] = user.id
      redirect '/tweets'
    end
  end

#  post '/signup' do
#    if !params.values.all? {|v| !v.blank?}
#      # flash[:error] = "Uh oh! Something's not filled in..."
#      redirect to '/signup'
#    else
#      @user = User.create(params)
#      session[:user_id] = @user.id
#      redirect to '/tweets'
#    end
#  end

  get '/login' do
    if is_logged_in?(session)
      redirect '/tweets'
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
#    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/tweets'
    else
      redirect '/login'
    end
  end

  get '/logout' do
    if is_logged_in?(session)
      session.clear
      redirect '/login'
    else
      redirect '/'
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end
end
