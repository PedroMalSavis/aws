class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def show
  end  

  def update
    respond_to do |format|
      if @user.update(user_params)
        rekognition = Aws::Rekognition::Client.new(region: 'us-west-2', access_key_id: $aws_key, secret_access_key: $aws_secret)
        @uri = @user.avatar.service_url
        @dir = @uri.split("/").fourth
        @key = @dir.split("?").first
        puts 'KEY IS:' + @key

        # resp = rekognition.detect_faces(
        #   {image:
        #     {s3_object:
        #       {bucket: 'soraaws',
        #         name: @key,
        #       },
        #     }, attributes: ['ALL'],
        #   }
        # )
        
        response = rekognition.detect_labels(
          {image:
            {s3_object:
              {bucket: 'soraaws',
                name: @key,
              },
            },
            max_labels: 1, 
            min_confidence: 70
          }
        )
        # response.labels.each do |label|
        #   puts "#{label.name}-#{label.confidence.to_i}"
        # end
        @user.update(notes: response.labels.first.name)
        # aws rekognition detect-labels --image '{"S3Object":{"Bucket": "soraaws", "Name":"DTDbcd8JCDLqRFjyooM39gEx"}}'


        # @emotions = resp.face_details[0].emotions
        # @user.update(notes: @emotions)


        # https://s3-us-west-2.amazonaws.com/soraaws/DTDbcd8JCDLqRFjyooM39gEx

        # flash[:emotions] = @emotions

        # labels = rekognition.detect_labels(
        #   # image: {  bytes: @item.images.first }
        #   {image:
        #     {s3_object:
        #       {bucket: 'soraaws', name: @item.images.first.service_url}
        #     }
        #   }
        # )
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