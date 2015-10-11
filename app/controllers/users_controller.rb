class UsersController < ApplicationController
  # Before actions to check paramters
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, only: [:edit, :destroy, :update]
  before_action :check_valid, only: [:edit, :destroy, :update]
  

  # GET /users/new
  def new
    # If a user logged in, redirect to articles page
    if current_user
      redirect_to articles_path
    end
    @user = User.new
  end


  # GET /users/1/edit
  def edit
  end


  # user /users
  # user /users.json
  def create
    @user = User.new(user_params)  
    respond_to do |format|
      if @user.save
        log_in @user
        format.html { redirect_to articles_path, notice: 'user was articlesfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to articles_path, notice: 'user was articlesfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    log_out
    @user.destroy
    respond_to do |format|
      format.html { redirect_to login_path, notice: 'user was articlesfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id]) 
    end

    # Check the authentication for :edit, :update, :destroy
    def check_valid
      unless @user == current_user
        render :status => :forbidden, :text => "HTTP Error 403 Forbidden"
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :bio, :username, :password, :password_confirmation, :interest_list)
    end
end
