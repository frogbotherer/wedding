class RsvpsController < ApplicationController

  def index
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to do |format|
      format.html
    end
  end



  # GET /users/1/rsvps/new
  def new
    @user = get_user
    @rsvp = Rsvp.new
    respond_to do |format|
      format.html
      format.json { render :json => @rsvp }
    end
  end

  # POST /users/1/rsvps
  def create
    @user = get_user

    # only admin can create adult RSVPs
    if !@current_user.is_admin? then 
      params[:rsvp][:is_child] = 1 
    end

    @rsvp = @user.rsvps.create(params[:rsvp])

    respond_to do |format|
      if @user.save && @rsvp.save
        format.html { redirect_to @user, :notice => 'RSVP was successfully created.' }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.json { render :json => @rsvp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /users/1/rsvps/2/edit
  def edit
    @user = get_user
    @rsvp = @user.rsvps.find(params[:id])
  end

  # PUT /users/1/rsvps/2
  def update
    @user = get_user
    @rsvp = @user.rsvps.find(params[:id])

    respond_to do |format|
      if @rsvp.update_attributes(params[:rsvp]) then # don't need to update User
        format.html { redirect_to @user, :notice => 'RSVP was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @rsvp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  def destroy
    @user = get_user
    @rsvp = @user.rsvps.find(params[:id])

    # users can only destroy children they've created; admin can do anything
    if current_user.is_admin? or @rsvp.is_child? then
      notice = "RSVP #{@rsvp.name} removed"
      @rsvp.destroy
    else
      notice = "Can't remove #{@rsvp.name}"
    end

    respond_to do |format|
      format.html { redirect_to @user, :notice => notice }
      format.json { head :ok }
    end
  end



private

  def get_user
    if current_user.is_admin? then User.find(params[:user_id]) else current_user end
  end
end
