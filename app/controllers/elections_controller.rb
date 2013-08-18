class ElectionsController < ApplicationController
  # GET /elections
  # GET /elections.json
  def index
    @elections = Election.all
    @unit = Unit.find(1)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @elections }
    end
  end

  def scheduled
    @elections = Election.scheduled
    @elections_by_date = @elections.group_by(&:held_on)
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @elections }
    end    
  end
  
  # GET /elections/1
  # GET /elections/1.json
  def show
    @election = Election.find_by_token(params[:token]) if params[:token]
    @election ||= Election.find(params[:id])

    unless (current_user && current_user.admin?) || @election.id == session[:election_id]
      redirect_to root_url 
    else
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @election }
    end
  end
  end

  # GET /elections/new
  # GET /elections/new.json
  def new
    @election = Election.new
    @teams = Team.where(lodge_id: params['lodge_id'])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @election }
    end
  end

  # GET /elections/1/edit
  def edit
    @election = Election.find(params[:id])
  end

  # POST /elections
  # POST /elections.json
  def create
    @election = Election.new(params[:election])

    respond_to do |format|
      if @election.save
        format.html { redirect_to @election, notice: 'Election was successfully created.' }
        format.json { render json: @election, status: :created, location: @election }
      else
        format.html { render action: "new" }
        format.json { render json: @election.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /elections/1
  # PUT /elections/1.json
  def update
    @election = Election.find(params[:id])

    respond_to do |format|
      if @election.update_attributes(params[:election])
        format.html { redirect_to @election, notice: 'Election was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @election.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /elections/1
  # DELETE /elections/1.json
  def destroy
    @election = Election.find(params[:id])
    @election.destroy

    respond_to do |format|
      format.html { redirect_to elections_url }
      format.json { head :no_content }
    end
  end
end
