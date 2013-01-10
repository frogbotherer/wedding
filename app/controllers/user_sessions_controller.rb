class UserSessionsController < ApplicationController
  skip_before_filter :require_login, :except => [:destroy]
  
  def new
    @user = User.new
  end
  
  def create
    respond_to do |format|

      if !params[:username].empty? then
        auto_login( User.where( :username => params[:username] ).first || false, params[:remember] )
        @user = @current_user
      else
        @user = login(params[:email],params[:password],params[:remember])
      end

      if @user then
        format.html { redirect_to( @user, :notice => 'Login successful.') }
        format.xml { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { flash.now[:alert] = "Login failed."; render :action => "new" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    logout
    redirect_to(:users, :notice => 'Logged out!')
  end

end
