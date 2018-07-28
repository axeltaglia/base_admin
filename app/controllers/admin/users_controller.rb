module Admin
  class UsersController < Admin::BaseController
    respond_to :json, :html
    before_action :set_user, only: [:show, :edit, :edit_password, :update, :destroy]

    # GET /users
    def index
      @users = User.all
    end

    # GET /users/1
    def show
    end

    # GET /users/new
    def new
      @user = User.new
      @url = admin_users_path
    end

    # GET /users/1/edit
    def edit
      @url = admin_user_path(@user)
    end

    # GET /edit_password/:id
    def edit_password
      @url = admin_user_path(@user)
    end

    # POST /users
    def create
      @user = User.new(user_params)
      if @user.save
        add_roles_profiles(user_params[:roles])
        flash[:notice] = t('admin.users.create.success')
        redirect_to admin_users_path
      else
        flash[:warning] = @user.errors.full_messages.uniq.join(', ')
        respond_with :new, :admin, :user
      end
    end

    # PATCH/PUT /users/1
    def update
      if @user.update(user_params)
        add_roles_profiles(user_params[:roles])
        flash[:notice] = t('admin.users.update.success')
        redirect_to admin_users_path
      else
        flash[:warning] = @user.errors.full_messages.uniq.join(', ')
        respond_with :edit, :admin, :user
      end
    end

    # DELETE /users/1
    def destroy
      @user.destroy
      respond_to do |format|
        format.html { redirect_to admin_users_path, notice: t('admin.users.destroy.success') }
      end
    end

    private 
      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation, :name, roles: [])
      end

      def add_roles_profiles(roles)
        roles.each do |role|
          @user.institution_owner = InstitutionOwner.find_or_create_by!(user_id: @user.id) if role == "institution_owner"
        end
      end
  end
end
