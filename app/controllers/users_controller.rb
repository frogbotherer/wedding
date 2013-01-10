class UsersController < ApplicationController

# uncomment this line if admin gets deleted
#  skip_before_filter :require_login, :only => [:new, :create, :activate]

  # GET /users
  # GET /users.json
  def index
    @users = if current_user.is_admin? then User.all else [current_user] end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = if current_user.is_admin? then User.find(params[:id]) else current_user end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = if current_user.is_admin? then User.find(params[:id]) else current_user end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, :notice => 'User was successfully created.' }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = if current_user.is_admin? then User.find(params[:id]) else current_user end

    # if password field isn't filled in, default to previous password
    if params[:user][:password].nil? || params[:user][:password] == ""
      params[:user][:password] = @user.password
      params[:user][:password_confirmation] = @user.password
    end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, :notice => 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = if current_user.is_admin? then User.find(params[:id]) else current_user end
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end
end
