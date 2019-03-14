# require 'aws-sdk-rails' 


class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def create
    @post = Post.new(post_params)
    respond_to do |format|
      if @post.save
        translator = Aws::Translate::Client.new(region: 'us-west-2', access_key_id: $aws_key, secret_access_key: $aws_secret)
        output = translator.translate_text(text: @post.content, source_language_code: 'en', target_language_code: 'fr')
        @post.update(content: output)

        # client = Aws::Rekognition::Client.new

        # resp = client.detect_labels(
        #          image: { bytes: File.read('magic.jpg') }
        #        )

        # resp.labels.each do |label|
        #   puts "#{label.name}-#{label.confidence.to_i}"
        # end
        # poly = Aws::Polly::Client.new(region: 'us-west-2')
        # puts 'speeching..'
        # speech = poly.synthesize_speech(output_format: 'mp3', text: "haha", voice_id: 'Joanna')
        # puts 'making file..'
        # IO.copy_stream(speech.audio_stream, 'haruna.mp3')
        format.js
      else
        format.json  { render json: @post.errors, status: :unprocessable_entity }
      end
    end
    current_user = User.third
    @posts = Post.all.order(created_at: :desc)
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to root_path, notice: t('helpers.successfully_updated') }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    @posts = Post.all
    respond_to do |format|
      format.html do
        redirect_to :back
      end
      format.js
    end
  end

private
  def set_post
    @post = Post.find(params[:id])
  end
  
  def post_params
    params.require(:post).permit(:buyer_id, :content)
  end
end