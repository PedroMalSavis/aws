class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def show
  end  

  def update
    respond_to do |format|
      if @user.update(user_params)
        Aws.config.update({
          region: 'us-west-2',
          credentials: Aws::Credentials.new(Rails.application.credentials.aws[:access_key], Rails.application.credentials.aws[:secret_access_key])
        })

        rekognition = Aws::Rekognition::Client.new(region: Aws.config[:region], credentials: Aws.config[:credentials])
        current_user = User.third
        @uri = current_user.avatar.service_url
        @dir = @uri.split("/").fourth
        @key = @dir.split("?").first
        puts @key

        resp = rekognition.detect_faces(
          {image:
            {s3_object:
              {bucket: 'soraaws',
                name: @key,
              },
            }, attributes: ['ALL'],
          }
        )
        
        @emotions = resp.face_details[0].emotions
        @user.update(notes: @emotions)
        # flash[:emotions] = @emotions

        # labels = rekognition.detect_labels(
        #   # image: {  bytes: @item.images.first }
        #   {image:
        #     {s3_object:
        #       {bucket: 'soraaws', name: @item.images.first.service_url}
        #     }
        #   }
        # )

        # flash[:labels] = labels
        format.html { redirect_to root_path, notice: 'ok la!' }
        # format.json { render :show, status: :ok, location: @user }
        # format.js
      else
        format.html { redirect_to root_path, notice: 'something wrong' }
        # format.html { render :edit }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(
       :name, :avatar, :email, :notes)
    end
end